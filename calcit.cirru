
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ decode-map-as
                  match (get reel :store)
                    (:some data) data
                    (:none) ({})
                  , app.schema/Store
                states $ :states store
              div
                {} $ :style $ merge ui/global
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
                when dev? $ comp-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
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
              {} $ :style $ merge ui/row
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
              {} $ :style $ merge ui/column
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
            respo.util.format :refer $ [] hsl
            [] respo-ui.core :as ui
            [] respo.core :refer $ [] defcomp defeffect list-> >> <> div button textarea span input
            [] respo.comp.space :refer $ [] =<
            [] app.config :refer $ [] dev?
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ :: 'Dynamic
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} (:title |Calcit) (:icon |http://cdn.tiye.me/logo/mvc-works.png) (:storage-key |hv-layout)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *reel
            -> reel-schema/reel (assoc :base store) (assoc :store store)
          :examples $ []
          :schema $ :: 'Ref 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            reset! *reel $ reel-updater updater @*reel op
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            .?!addEventListener js/window |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            let
                raw $ .?!getItem js/localStorage $
                  get config/site :storage-key
                  , .unwrap-or |hv-layout
              when (js-present? raw)
                dispatch! $ :: :hydrate-storage $ parse-cirru-edn (unsafe-coerce raw String)
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target (.querySelector js/document |.app)
          :examples $ []
          :schema $ :: 'JsObject
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            do
              .?!setItem js/localStorage
                (get config/site :storage-key) .unwrap-or |hv-layout
                format-cirru-edn $ decode-map-as
                  match (get @*reel :store)
                    (:some data) data
                    (:none) ({})
                  , Store
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ assert-type (refresh-reel @*reel store updater) (:: 'Map 'Tag 'Dynamic)
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'repeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn repeat! (duration cb)
            do
              js/setTimeout
                fn () (cb)
                  repeat! (* 1000 duration) cb
                * 1000 duration
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Number $ :: 'Fn
              {} (:return 'Unit)
                :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :refer $ [] Store store
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:states 'Map) (:content 'String)
          :examples $ []
          :schema $ :: 'StructDef
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
                decode-map-as (update-states store cursor s) app.schema/Store
              (:content data) (assoc store :content data)
              (:hydrate-storage data) (decode-map-as data app.schema/Store)
              _ $ do (println "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Enum 'String 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ [] respo.cursor :refer $ [] update-states
