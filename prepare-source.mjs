import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {mkdirSync,readFileSync,writeFileSync} from 'node:fs';
const run=(...a)=>execFileSync(process.env.HV_QUERY_CLI||'calcit',a,{encoding:'utf8',maxBuffer:10*1024*1024,stdio:['ignore','pipe','pipe']});
const q=(...a)=>JSON.parse(run('query',...a,'--format','json')).data;
mkdirSync('acceptance',{recursive:true});
function inventory(){
  const defs=[];
  for(const ns of q('ns').namespaces){
    const names=run('query','defs',ns).split('\n').filter(x=>/^  \S/.test(x)).map(x=>x.trim().split(' ')[0]);
    assert.equal(names.length,q('ns',ns).definition_count);
    for(const n of names)defs.push(q('def',ns+'/'+n));
  }
  assert.equal(defs.length,25);assert.equal(defs.reduce((n,d)=>n+d.tests.length,0),3);return defs;
}
if(process.argv[2]==='inventory'){
  writeFileSync('acceptance/reviewed.json',JSON.stringify(inventory(),null,2));process.exit(0);
}
assert.equal(run('-v').trim(),'0.30.1');run('docs','agents','--contract');
const before=inventory(),config=q('config');assert.deepEqual(before,JSON.parse(readFileSync('acceptance/reviewed.json','utf8')));
const expected=structuredClone(before),ops=[];
for(const [id,path] of [['app.comp.container/comp-container','@3.2.1.1.1.0'],['app.comp.expr/comp-expr-horizontal','@3.1.1.1.0'],['app.comp.expr/comp-expr-vertical','@3.1.1.1.0']]){
  const shown=JSON.parse(run('tree','show',id,'--path',path,'--format','json'));assert.equal(shown.tree,'merge');
  const def=expected.find(d=>d.id===id),indices=path.slice(1).split('.').map(Number);let node=def.code;
  for(const i of indices.slice(0,-1))node=node[i];assert.equal(node[indices.at(-1)],'merge');node[indices.at(-1)]='.merge';
  ops.push(['tree','replace',id,'--path',path,'--input-format','cirru','--code','quote .merge','--expect','quote merge']);
}
const tested=expected.find(d=>d.id==='app.updater/updater');
const test=tested.tests.find(t=>t.name==='updates-state-subtree-without-nesting-store');
assert.deepEqual(test.tags,['regression','unit']);let testChanges=0;
function migrateTest(node){
  if(!Array.isArray(node))return;
  if(node[0]==='option:unwrap'){assert.equal(node.length,2);node[0]='.unwrap';testChanges++;}
  node.forEach(migrateTest);
}
migrateTest(test.code);assert.equal(testChanges,3);
ops.push(['edit','add-test',tested.id,test.name,'--tags',test.tags.join(','),'--overwrite','--input-format','json-ast','--code',JSON.stringify(test.code)]);
const reel=expected.find(d=>d.id==='app.main/*reel');
const oldInitializer=['assert-type',['typed/new-reel','store'],['::',"'reel.typed/State","'app.schema/Op","'app.schema/Store"]];
assert.deepEqual(reel.code,['defref','*reel',oldInitializer]);
assert.deepEqual(q('def','reel.typed/new-reel').code,['defn','new-reel',['base'],['State',':base','base',':store','base',':records',['[]'],':pointer',['Option',':none'],':stopped?','false',':display?','false',':merged?','false']]);
const initializer=['typed/State',':base','store',':store','store',':records',['[]'],':pointer',['Option',':none'],':stopped?','false',':display?','false',':merged?','false'];
const reelShown=JSON.parse(run('tree','show',reel.id,'--path','@2','--format','json'));assert.deepEqual(reelShown.tree,oldInitializer);
reel.code[2]=initializer;
ops.push(['tree','replace',reel.id,'--path','@2','--input-format','json-ast','--code',JSON.stringify(initializer),'--expect',"quote (assert-type (typed/new-reel store) (:: 'reel.typed/State 'app.schema/Op 'app.schema/Store))"]);
const renderer=expected.find(d=>d.id==='app.main/render-app!');
assert.equal(renderer.code[3][3],'dispatch!');
const adapter=['fn',['op'],['hint-fn',['{}',[':args',['[]',"'Dynamic"]],[':return',"'Unit"]]],['if',['enum?','op'],['dispatch!','op'],['raise','|Expected a layout operation enum']]];
renderer.code[3][3]=adapter;
ops.push(['tree','replace',renderer.id,'--path','@3.3','--input-format','json-ast','--code',JSON.stringify(adapter),'--expect','quote dispatch!']);
writeFileSync('acceptance/before.json',JSON.stringify(before,null,2));writeFileSync('acceptance/operations.json',JSON.stringify(ops,null,2));
const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];const preview=JSON.parse(run(...args,'--dry-run'));assert.ok(preview.scoped_revision);
writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));writeFileSync('acceptance/applied.json',run(...args,'--expect-revision',preview.scoped_revision));
assert.deepEqual(inventory(),expected);assert.deepEqual(q('config'),config);
writeFileSync('acceptance/after.json',JSON.stringify(expected,null,2));writeFileSync('acceptance/snapshot-blob.txt',execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}));
console.log('25 full views guarded: 3 Map merge, 3 attached Option unwrap, empty typed State initializer and checked Dynamic render adapter; original 3 test names/tags/assertions, root schema, HUD, FFI and config preserved');
