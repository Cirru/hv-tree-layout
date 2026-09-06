
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |app)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $
                    get (unsafe-coerce reel Dynamic) :store
                    , .unwrap-or ({})
                  states $
                    get store :states
                    , .unwrap-or ({})
                div
                  {} $ :style
                    merge ui/global $ {}
                      :color $ hsl 0 0 100
                      :padding 16
                  div ({})
                    comp-expr-horizontal $ parse-cirru-list (inline |page-demo.cirru)
                  =< nil 200
                  comp-expr-horizontal $ parse-cirru-list (inline |updater-demo.cirru)
                  =< nil 200
                  comp-expr-horizontal $ parse-cirru-list (inline |bookmark-demo.cirru)
                  =< nil 200
                  when dev? $ comp-reel (>> states :reel) reel ({})
          :examples $ []
          :schema $ :: 'Dynamic
        'inline $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defmacro inline (path)
              read-file $ str |data/ path
          :examples $ []
          :schema $ :: 'Macro
            {}
              :capabilities $ #{} :fs-read
              :expansion $ :: 'Expr 'String
              :required $ [] (:: 'Expr 'String)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require
            [] respo.util.format :refer $ [] hsl
            [] respo-ui.core :as ui
            [] respo.core :refer $ [] defcomp defeffect >> <> div button textarea span input
            [] respo.comp.space :refer $ [] =<
            [] reel.comp.reel :refer $ [] comp-reel
            [] respo-md.comp.md :refer $ [] comp-md
            [] app.config :refer $ [] dev?
            [] app.comp.expr :refer $ [] comp-expr-horizontal
    'app.comp.expr $ %{} 'FileEntry
      :defs $ {}
        'comp-empty $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-empty () $ div
              {} $ :style
                {} (:width 12) (:height 12) (:margin 12)
                  :border $ str "|1px solid " (hsl 0 0 100)
                  :border-radius |8px
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-expr-horizontal $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-expr-horizontal (expr)
              list->
                {} $ :style
                  merge (unsafe-coerce ui/row Dynamic)
                    if
                      list? $
                        first expr
                        , .unwrap-or |
                      {} (:font-family ui/font-code) (:padding-left 32)
                        :border-top $ str "|1px solid " (hsl 0 0 20)
                        :padding-top 4
                      {} (:font-family ui/font-code)
                        :border-top $ str "|1px solid " (hsl 0 0 20)
                        :padding-top 4
                -> expr $ map-indexed
                  fn (idx child)
                    [] idx $ cond
                        string? child
                        div ({}) (comp-leaf child)
                      (empty? child) (comp-empty)
                      true $ comp-expr-vertical child
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-expr-vertical $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-expr-vertical (expr)
              list->
                {} $ :style
                  merge (unsafe-coerce ui/column Dynamic)
                    if
                      list? $
                        first expr
                        , .unwrap-or |
                      {} (:padding-top 32)
                        :border-left $ str "|1px solid " (hsl 0 0 30)
                        :padding-left 3
                      {}
                        :border-left $ str "|1px solid " (hsl 0 0 30)
                        :padding-left 3
                -> expr $ map-indexed
                  fn (idx child)
                    [] idx $ cond
                        string? child
                        div ({}) (comp-leaf child)
                      (empty? child) (comp-empty)
                      true $ comp-expr-horizontal child
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-leaf (text)
              div
                {} $ :style
                  {} (:display :inline-block) (:padding "|0 4px")
                    :background-color $ hsl 0 0 20
                    :border-radius |4px
                    :font-size 14
                    :line-height |24px
                    :margin |2px
                <> text
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.expr $ :require
            respo.util.format :refer $ [] hsl
            [] respo-ui.core :as ui
            [] respo.core :refer $ [] defcomp defeffect list-> >> <> div button textarea span input
            [] respo.comp.space :refer $ [] =<
            [] app.config :refer $ [] dev?
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def dev? $ = |dev
              (get-env |mode) .unwrap-or |release
          :examples $ []
          :schema $ :: 'Dynamic
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:title |Calcit) (:icon |http://cdn.tiye.me/logo/mvc-works.png) (:storage-key |hv-layout)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.config)
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op)
              when config/dev? $ println |Dispatch: op
              reset! *reel $ reel-updater updater @*reel op
          :examples $ []
          :schema $ :: 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              println "|Running mode:" $ if config/dev? |dev |release
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              .?!addEventListener js/window |beforeunload persist-storage!
              repeat! 60 persist-storage!
              let
                  raw $ .?!getItem js/localStorage
                    (get config/site :storage-key) .unwrap-or |hv-layout
                when (js-present? raw)
                  dispatch! $ :: :hydrate-storage
                    parse-cirru-edn $ unsafe-coerce raw String
              println "|App started."
          :examples $ []
          :schema $ :: 'Dynamic
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def mount-target $ .querySelector js/document |.app
          :examples $ []
          :schema $ :: 'Dynamic
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! (? e)
              .?!setItem js/localStorage
                (get config/site :storage-key) .unwrap-or |hv-layout
                format-cirru-edn $
                  get (unsafe-coerce @*reel Dynamic) :store
                  , .unwrap-or ({})
          :examples $ []
          :schema $ :: 'Dynamic
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Dynamic
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Dynamic
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn repeat! (duration cb)
              js/setTimeout
                fn () (cb)
                  repeat! (* 1000 duration) cb
                * 1000 duration
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def store $ {}
              :states $ {}
              :content |
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.schema)
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn updater (store op op-id op-time)
              match op
                (:states cursor s) (update-states store cursor s)
                (:content data) (assoc store :content data)
                (:hydrate-storage data) data
                _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            [] respo.cursor :refer $ [] update-states
