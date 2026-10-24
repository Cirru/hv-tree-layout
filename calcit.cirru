
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
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
                =< nil 200
                comp-expr-horizontal $ parse-cirru-list $ inline |updater-demo.cirru
                =< nil 200
                comp-expr-horizontal $ parse-cirru-list $ inline |bookmark-demo.cirru
                =< nil 200
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'app.schema/Op 'app.schema/Store
        'inline $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defmacro inline (path)
            read-file $ str |data/ path
          :examples $ []
          :schema $ :: 'Macro $ {}
            :capabilities $ #{} :fs-read
            :expansion $ :: 'Expr 'String
            :required $ [] $ :: 'Expr 'String
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
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ []
        'comp-expr-horizontal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-expr-horizontal (expr)
            list->
              {} $ :style $ .merge ui/row
                if
                  list? $
                    first expr
                    , .unwrap-or |
                  {} (:font-family ui/font-code) (:padding-left 32)
                    :border-top $ str "|1px solid " $ hsl 0 0 20
                    :padding-top 4
                  {} (:font-family ui/font-code)
                    :border-top $ str "|1px solid " $ hsl 0 0 20
                    :padding-top 4
              -> expr $ map-indexed $ fn (idx child)
                [] idx $ cond
                    string? child
                    div ({}) (comp-leaf child)
                  (list? child)
                    if (empty? child) (comp-empty) (comp-expr-vertical child)
                  true $ comp-leaf $ str child
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'List 'Dynamic
        'comp-expr-vertical $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-expr-vertical (expr)
            list->
              {} $ :style $ .merge ui/column
                if
                  list? $
                    first expr
                    , .unwrap-or |
                  {} (:padding-top 32)
                    :border-left $ str "|1px solid " $ hsl 0 0 30
                    :padding-left 3
                  {}
                    :border-left $ str "|1px solid " $ hsl 0 0 30
                    :padding-left 3
              -> expr $ map-indexed $ fn (idx child)
                [] idx $ cond
                    string? child
                    div ({}) (comp-leaf child)
                  (list? child)
                    if (empty? child) (comp-empty) (comp-expr-horizontal child)
                  true $ comp-leaf $ str child
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'List 'Dynamic
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
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'String
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
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:title |Calcit) (:icon |http://cdn.tiye.me/logo/mvc-works.png) (:storage-key |hv-layout)
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel
            typed/State :base store :store store :records ([]) :pointer (Option :none) :stopped? false :display? false :merged? false
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.schema/Op 'app.schema/Store
        '*storage-error? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *storage-error? false
          :examples $ []
          :schema $ :: 'Ref 'Bool
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            let
                op-id $ generate-id!
                op-time $ host/now-ms
              reset! *reel $ match (typed/decode-control op)
                (:some control) (typed/apply-control updater @*reel control)
                (:none)
                  typed/record-op updater @*reel (app.schema/decode-op op) op-id op-time
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch! *reel :changes $ fn (_reel _previous) (render-app!) &unit
            listen-devtools! |k dispatch!
            browser/add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            let
                raw $ browser/storage-get $ .unwrap-or (get config/site :storage-key) |hv-layout
              when (.some? raw)
                restore-storage! $ .unwrap raw
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target
            .unwrap $ respo.ffi.browser/query-selector |.app
          :examples $ []
          :schema $ :: 'respo.dom/DomElement
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            if @*storage-error? &unit $ browser/storage-set!
              .unwrap-or (get config/site :storage-key) |hv-layout
              format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
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
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel)
              fn (op)
                hint-fn $ {}
                  :args $ [] 'Dynamic
                  :return 'Unit
                if (enum? op) (dispatch! op) (raise "|Expected a layout operation enum")
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration cb)
            browser/set-timeout!
              fn () (cb) (repeat! duration cb)
              * 1000 duration
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
            :features $ #{} :js-ffi
        'restore-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn restore-storage! (raw)
            try
              do
                dispatch! $ app.schema/Op :hydrate-storage $ parse-cirru-edn raw
                reset! *storage-error? false
                , &unit
              fn (message) (reset! *storage-error? true)
                hud! |error $ str "|Cannot restore stored layout: " message
                , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render! clear-cache!
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
            :states (:: 'List 'Dynamic) 'Dynamic
            :content 'String
            :hydrate-storage 'Dynamic
          :examples $ []
          :schema $ :: 'EnumDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Dynamic 'Dynamic
            :content 'String
          :examples $ []
          :schema $ :: 'StructDef
        'decode-op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-op (op)
            match op
              (:states cursor data)
                Op :states
                  decode-map-as cursor $ :: 'List 'Dynamic
                  , data
              (:content data)
                Op :content $ decode-map-as data 'String
              (:hydrate-storage data) (Op :hydrate-storage data)
              _ $ raise $ str "|Unknown layout operation: " op
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Op)
            :args $ [] 'Enum
          :tests $ [] $ %{} 'TestEntry (:name |adapts-legacy-enum-protocol)
            :code $ quote $ do
              assert= (Op :content |legacy)
                decode-op $ :: :content |legacy
              assert= true $ try
                do
                  decode-op $ :: :content 31
                  , false
                fn (_error) true
            :tags $ #{} :regression :unit
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states ({}) :content |
          :examples $ []
          :schema $ :: 'app.schema/Store
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
                  :: 'Map 'Dynamic 'Dynamic
              (:content data) (assoc store :content data)
              (:hydrate-storage data)
                decode-map-as
                  if (struct? data) (&struct:to-map data) data
                  , app.schema/Store
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'app.schema/Op 'String 'Number
          :tests $ []
            %{} 'TestEntry (:name |hydrates-stored-content)
              :code $ quote $ is=
                app.schema/Store :states ({}) :content |restored
                updater
                  app.schema/Store :states ({}) :content |old
                  app.schema/Op :hydrate-storage $ parse-cirru-edn $ format-cirru-edn
                    app.schema/Store :states ({}) :content |restored
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
                assert= false $ .unwrap $ get-in (:states nested) ([] :viewer |mixed 7 :data)
                assert= 31 $ .unwrap $ get (:states root) |legacy
                assert= false $ contains? (:states root) :states
                assert= |root $ .unwrap $ get (:states root) :data
                assert= |keep $ :content root
              :tags $ #{} :regression :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ calcit.test :refer $ is=
