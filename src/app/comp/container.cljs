
(ns app.comp.container
  (:require [hsl.core :refer [hsl]]
            [respo-ui.core :as ui]
            [respo.core
             :refer
             [defcomp defeffect cursor-> <> div button textarea span input]]
            [respo.comp.space :refer [=<]]
            [reel.comp.reel :refer [comp-reel]]
            [respo-md.comp.md :refer [comp-md]]
            [app.config :refer [dev?]]
            [app.comp.expr :refer [comp-expr-horizontal]]
            [shadow.resource :refer [inline]]
            [cljs.reader :refer [read-string]]))

(defcomp
 comp-container
 (reel)
 (let [store (:store reel), states (:states store)]
   (div
    {:style (merge ui/global {:color (hsl 0 0 100), :padding 16})}
    (div {} (comp-expr-horizontal (read-string (inline "page-demo.edn"))))
    (=< nil 200)
    (comp-expr-horizontal (read-string (inline "updater-demo.edn")))
    (=< nil 200)
    (comp-expr-horizontal (read-string (inline "bookmark-demo.edn")))
    (=< nil 200)
    (when dev? (cursor-> :reel comp-reel states reel {})))))
