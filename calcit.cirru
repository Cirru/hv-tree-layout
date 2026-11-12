
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |js-ffi/
      :type-slots $ {} $ :dispatch-op 'app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel on-control)
            let
                store $ :store reel
                states $ :states store
              div
                {} $ :style $ .merge ui/global
                  {}
                    :color $ hsl 0 0 100
                    :padding 16
                div ({})
                  comp-expr-horizontal $ parse-cirru-list $ inline |page-demo.cirru
                respo.comp.space/space-y 200
                comp-expr-horizontal $ parse-cirru-list $ inline |updater-demo.cirru
                respo.comp.space/space-y 200
                comp-expr-horizontal $ parse-cirru-list $ inline |bookmark-demo.cirru
                respo.comp.space/space-y 200
                if dev?
                  Some $ comp-typed-reel (>> states :reel) reel ({}) on-control
                  , None
          :examples $ []
          :schema $ quote $ Fn (reel.typed/State app.schema/Op app.schema/Store)
            Fn reel.typed/Control $ -> Unit
            -> respo.schema/Component
        'inline $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defmacro inline (path)
            read-file $ str |data/ path
          :examples $ []
          :schema $ quote $ Macro (Expr String)
            -> $ Expr String
            :capabilities :fs-read
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp defeffect >> <> div button textarea span input
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev?
            app.comp.expr :refer $ comp-expr-horizontal
    'app.comp.expr $ %{} 'FileEntry
      :defs $ {}
        'comp-empty $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-empty ()
            div $ {} $ :style
              {} (:width 12) (:height 12) (:margin 12)
                :border $ str "|1px solid " $ hsl 0 0 100
                :border-radius |8px
          :examples $ []
          :schema $ quote $ Fn (-> respo.schema/Component)
        'comp-expr-horizontal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-expr-horizontal (expr)
            let
                nested-head? $ match (first expr)
                  (:some head)
                    match head
                      (String _token) false
                      (List _children) true
                  (:none) false
                style $ {} (:font-family ui/font-code)
                  :border-top $ str "|1px solid " $ hsl 0 0 20
                  :padding-top 4
              respo.core/keyed->
                {} $ :style $ .merge ui/row
                  if nested-head? (assoc style :padding-left 32) style
                map-indexed expr $ fn (idx child)
                  hint-fn $ Fn Number CirruNode $ -> respo.schema/ChildPair
                  respo.util.detect/make-child-pair idx $ match child
                    (String token)
                      div ({}) (comp-leaf token)
                    (List branch)
                      if (empty? branch) (comp-empty) (comp-expr-vertical branch)
          :examples $ []
          :schema $ quote $ Fn (List CirruNode) (-> respo.schema/Component)
        'comp-expr-vertical $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-expr-vertical (expr)
            let
                nested-head? $ match (first expr)
                  (:some head)
                    match head
                      (String _token) false
                      (List _children) true
                  (:none) false
                style $ {}
                  :border-left $ str "|1px solid " $ hsl 0 0 30
                  :padding-left 3
              respo.core/keyed->
                {} $ :style $ .merge ui/column
                  if nested-head? (assoc style :padding-top 32) style
                map-indexed expr $ fn (idx child)
                  hint-fn $ Fn Number CirruNode $ -> respo.schema/ChildPair
                  respo.util.detect/make-child-pair idx $ match child
                    (String token)
                      div ({}) (comp-leaf token)
                    (List branch)
                      if (empty? branch) (comp-empty) (comp-expr-horizontal branch)
          :examples $ []
          :schema $ quote $ Fn (List CirruNode) (-> respo.schema/Component)
        'comp-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-leaf (text)
            div
              {} $ :style $ {} (:display :inline-block) (:padding "|0 4px")
                :background-color $ hsl 0 0 20
                :border-radius |4px
                :font-size 14
                :line-height |24px
                :margin |2px
              <> text
          :examples $ []
          :schema $ quote $ Fn String (-> respo.schema/Component)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.expr
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp defeffect list-> >> <> div button textarea span input
            respo.comp.space :refer $ =<
            app.config :refer $ dev?
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ quote Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:title |Calcit) (:icon |http://cdn.tiye.me/logo/mvc-works.png) (:storage-key |hv-layout)
          :examples $ []
          :schema $ quote $ Map Tag String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel
            typed/State :base store :store store :records ([]) :pointer None :stopped? false :display? false :merged? false
          :examples $ []
          :schema $ quote $ Ref (typed/State app.schema/Op Store)
        '*storage-error? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *storage-error? false
          :examples $ []
          :schema $ quote $ Ref Bool
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            reset! *reel $ typed/record-op updater @*reel op (generate-id!) (host/now-ms)
            , &unit
          :examples $ []
          :schema $ quote $ Fn app.schema/Op (-> Unit) (:features :io :js-ffi :state)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch! *reel :changes $ fn (_reel _previous) (render-app!) &unit
            listen-devtools! |k on-control!
            browser/add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            let
                raw $ browser/storage-get $ .unwrap-or (get config/site :storage-key) |hv-layout
              when (.some? raw)
                restore-storage! $ .unwrap raw
            println "|App started."
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ respo.ffi.browser/query-selector |.app
          :examples $ []
          :schema $ quote respo.dom/DomElement
        'on-control! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-control! (control)
            reset! *reel $ typed/apply-control updater @*reel control
            , &unit
          :examples $ []
          :schema $ quote $ Fn typed/Control (-> Unit) (:features :io :state)
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            if @*storage-error? &unit $ browser/storage-set!
              .unwrap-or (get config/site :storage-key) |hv-layout
              format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi :state)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                add-watch! *reel :changes $ fn (_reel _previous) (render-app!) &unit
                reset! *reel $ typed/refresh updater @*reel store
                hud! |ok~ |Ok
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! mount-target
              fn () $ comp-container @*reel on-control!
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration cb)
            browser/set-timeout!
              fn () (cb) (repeat! duration cb)
              * 1000 duration
            , &unit
          :examples $ []
          :schema $ quote $ Fn Number
            Fn $ -> Unit
            -> Unit
            :features :js-ffi
        'restore-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn restore-storage! (raw)
            try
              do
                dispatch! $ app.schema/Op :hydrate-storage $ app.schema/decode-store (parse-cirru-edn raw)
                reset! *storage-error? false
                , &unit
              fn (message) (reset! *storage-error? true)
                hud! |error $ str "|Cannot restore stored layout: " message
                , &unit
          :examples $ []
          :schema $ quote $ Fn String (-> Unit) (:features :io :js-ffi :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :refer $ Store store
            reel.util :refer $ listen-devtools!
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            js-ffi.browser :as browser
            reel.typed :as typed
            js-ffi.shared :as host
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (List respo.schema/CoordKey) Dynamic
            :content String
            :hydrate-storage app.schema/Store
          :examples $ []
          :schema $ quote EnumDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ Map respo.schema/CoordKey Dynamic
            :content String
          :examples $ []
          :schema $ quote StructDef
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (data)
            decode-map-as
              if (struct? data) (&struct:to-map data) data
              , app.schema/Store
          :examples $ []
          :schema $ quote $ Fn T (-> Store) (:generics T)
          :tests $ [] $ %{} 'TestEntry (:name |checks-legacy-storage-content)
            :code $ quote $ do
              assert=
                Store :states ({}) :content |legacy
                decode-store $ {}
                  :states $ {}
                  :content |legacy
              assert= true $ try
                do
                  decode-store $ {}
                    :states $ {}
                    :content 31
                  , false
                fn (_error) true
            :tags $ #{} :regression :unit
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states ({}) :content |
          :examples $ []
          :schema $ quote Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor s)
                assoc store :states $ decode-map-as
                  respo.cursor/update-state-tree (:states store) cursor s
                  Map respo.schema/CoordKey Dynamic
              (:content data) (assoc store :content data)
              (:hydrate-storage data) data
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ quote $ Fn app.schema/Store app.schema/Op String Number (-> app.schema/Store) (:features :io)
          :tests $ []
            %{} 'TestEntry (:name |hydrates-stored-content)
              :code $ quote $ is=
                app.schema/Store :states ({}) :content |restored
                updater
                  app.schema/Store :states ({}) :content |old
                  app.schema/Op :hydrate-storage $ app.schema/decode-store $ parse-cirru-edn
                    format-cirru-edn $ app.schema/Store :states ({}) :content |restored
                  , |test 0
              :tags $ #{} :storage :unit
            %{} 'TestEntry (:name |updates-state-subtree-without-nesting-store)
              :code $ quote $ let
                  original $ app.schema/Store :states
                    {} $ |legacy 31
                    , :content |keep
                  nested $ updater original
                    app.schema/Op :states ([] :viewer |mixed 7) false
                    , |nested 1
                  root $ updater nested
                    app.schema/Op :states ([]) |root
                    , |root 2
                assert= (Result :ok false)
                  get-in (:states nested) ([] :viewer |mixed 7 :data)
                assert= (Some 31)
                  get (:states root) |legacy
                assert= false $ contains? (:states root) :states
                assert= (Some |root)
                  get (:states root) :data
                assert= |keep $ :content root
              :tags $ #{} :regression :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ calcit.test :refer $ is=
