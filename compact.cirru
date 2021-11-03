
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
    :version |0.0.1
  :files $ {}
    |app.comp.expr $ {}
      :ns $ quote
        ns app.comp.expr $ :require
          respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp defeffect list-> >> <> div button textarea span input
          [] respo.comp.space :refer $ [] =<
          [] app.config :refer $ [] dev?
      :defs $ {}
        |comp-expr-horizontal $ quote
          defcomp comp-expr-horizontal (expr)
            list->
              {} $ :style
                merge ui/row
                  {} (:font-family ui/font-code)
                    :border-top $ str "\"1px solid " (hsl 0 0 20)
                    :padding-top 4
                  if
                    list? $ first expr
                    {} $ :padding-left 32
              -> expr $ map-indexed
                fn (idx child)
                  [] idx $ cond
                      string? child
                      div ({}) (comp-leaf child)
                    (empty? child) (comp-empty)
                    true $ comp-expr-vertical child
        |comp-leaf $ quote
          defcomp comp-leaf (text)
            div
              {} $ :style
                {} (:display :inline-block) (:padding "\"0 4px")
                  :background-color $ hsl 0 0 20
                  :border-radius "\"4px"
                  :font-size 14
                  :line-height "\"24px"
                  :margin "\"2px"
              <> text
        |comp-empty $ quote
          defcomp comp-empty () $ div
            {} $ :style
              {} (:width 12) (:height 12) (:margin 12)
                :border $ str "\"1px solid " (hsl 0 0 100)
                :border-radius "\"8px"
        |comp-expr-vertical $ quote
          defcomp comp-expr-vertical (expr)
            list->
              {} $ :style
                merge ui/column
                  {}
                    :border-left $ str "\"1px solid " (hsl 0 0 30)
                    :padding-left 3
                  if
                    list? $ first expr
                    {} $ :padding-top 32
              -> expr $ map-indexed
                fn (idx child)
                  [] idx $ cond
                      string? child
                      div ({}) (comp-leaf child)
                    (empty? child) (comp-empty)
                    true $ comp-expr-horizontal child
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp defeffect >> <> div button textarea span input
          [] respo.comp.space :refer $ [] =<
          [] reel.comp.reel :refer $ [] comp-reel
          [] respo-md.comp.md :refer $ [] comp-md
          [] app.config :refer $ [] dev?
          [] app.comp.expr :refer $ [] comp-expr-horizontal
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (reel)
            let
                store $ :store reel
                states $ :states store
              div
                {} $ :style
                  merge ui/global $ {}
                    :color $ hsl 0 0 100
                    :padding 16
                div ({})
                  comp-expr-horizontal $ parse-cirru (inline "\"page-demo.cirru")
                =< nil 200
                comp-expr-horizontal $ parse-cirru (inline "\"updater-demo.cirru")
                =< nil 200
                comp-expr-horizontal $ parse-cirru (inline "\"bookmark-demo.cirru")
                =< nil 200
                when dev? $ comp-reel (>> states :reel) reel ({})
        |inline $ quote
          defmacro inline (path)
            read-file $ str "\"data/" path
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |store $ quote
          def store $ {}
            :states $ {}
            :content |
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require
          [] respo.cursor :refer $ [] update-states
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data op-id op-time)
            case-default op
              do (println "\"unknown op:" op) store
              :states $ update-states store op-data
              :content $ assoc store :content op-data
              :hydrate-storage op-data
    |app.main $ {}
      :ns $ quote
        ns app.main $ :require
          respo.core :refer $ render! clear-cache!
          app.comp.container :refer $ comp-container
          app.updater :refer $ updater
          app.schema :as schema
          reel.util :refer $ listen-devtools!
          reel.core :refer $ reel-updater refresh-reel
          reel.schema :as reel-schema
          app.config :as config
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
      :defs $ {}
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
        |persist-storage! $ quote
          defn persist-storage! () $ .!setItem js/localStorage (:storage-key config/site)
            format-cirru-edn $ :store @*reel
        |mount-target $ quote
          def mount-target $ .!querySelector js/document |.app
        |*reel $ quote
          defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            render-app!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            .!addEventListener js/window |beforeunload $ fn (event) (persist-storage!)
            repeat! 60 persist-storage!
            let
                raw $ .!getItem js/localStorage (:storage-key config/site)
              when (some? raw)
                dispatch! :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println "\"Dispatch:" op
            reset! *reel $ reel-updater updater @*reel op op-data
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (remove-watch *reel :changes) (clear-cache!)
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              reset! *reel $ refresh-reel @*reel schema/store updater
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |repeat! $ quote
          defn repeat! (duration cb)
            js/setTimeout
              fn () (cb)
                repeat! (* 1000 duration) cb
              * 1000 duration
    |app.config $ {}
      :ns $ quote (ns app.config)
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode")
        |site $ quote
          def site $ {} (:title "\"Calcit") (:icon "\"http://cdn.tiye.me/logo/mvc-works.png") (:storage-key "\"hv-layout")
