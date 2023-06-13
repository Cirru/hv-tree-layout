
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |respo-markdown.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
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
                  comp-expr-horizontal $ parse-cirru-list (inline "\"page-demo.cirru")
                =< nil 200
                comp-expr-horizontal $ parse-cirru-list (inline "\"updater-demo.cirru")
                =< nil 200
                comp-expr-horizontal $ parse-cirru-list (inline "\"bookmark-demo.cirru")
                =< nil 200
                when dev? $ comp-reel (>> states :reel) reel ({})
        |inline $ quote
          defmacro inline (path)
            read-file $ str "\"data/" path
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
    |app.comp.expr $ {}
      :defs $ {}
        |comp-empty $ quote
          defcomp comp-empty () $ div
            {} $ :style
              {} (:width 12) (:height 12) (:margin 12)
                :border $ str "\"1px solid " (hsl 0 0 100)
                :border-radius "\"8px"
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
      :ns $ quote
        ns app.comp.expr $ :require
          respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp defeffect list-> >> <> div button textarea span input
          [] respo.comp.space :refer $ [] =<
          [] app.config :refer $ [] dev?
    |app.config $ {}
      :defs $ {}
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode")
        |site $ quote
          def site $ {} (:title "\"Calcit") (:icon "\"http://cdn.tiye.me/logo/mvc-works.png") (:storage-key "\"hv-layout")
      :ns $ quote (ns app.config)
    |app.main $ {}
      :defs $ {}
        |*reel $ quote
          defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println "\"Dispatch:" op
            reset! *reel $ reel-updater updater @*reel op op-data
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
        |mount-target $ quote
          def mount-target $ .!querySelector js/document |.app
        |persist-storage! $ quote
          defn persist-storage! () $ .!setItem js/localStorage (:storage-key config/site)
            format-cirru-edn $ :store @*reel
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (remove-watch *reel :changes) (clear-cache!)
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              reset! *reel $ refresh-reel @*reel schema/store updater
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
        |repeat! $ quote
          defn repeat! (duration cb)
            js/setTimeout
              fn () (cb)
                repeat! (* 1000 duration) cb
              * 1000 duration
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
    |app.schema $ {}
      :defs $ {}
        |store $ quote
          def store $ {}
            :states $ {}
            :content |
      :ns $ quote (ns app.schema)
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data op-id op-time)
            case-default op
              do (println "\"unknown op:" op) store
              :states $ update-states store op-data
              :content $ assoc store :content op-data
              :hydrate-storage op-data
      :ns $ quote
        ns app.updater $ :require
          [] respo.cursor :refer $ [] update-states
