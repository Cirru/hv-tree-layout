
(ns app.comp.expr
  (:require [hsl.core :refer [hsl]]
            [respo-ui.core :as ui]
            [respo.core
             :refer
             [defcomp defeffect list-> cursor-> <> div button textarea span input]]
            [respo.comp.space :refer [=<]]
            [app.config :refer [dev?]]))

(declare comp-expr-vertical)

(declare comp-expr-horizontal)

(defcomp
 comp-empty
 ()
 (div
  {:style {:width 12,
           :height 12,
           :margin 12,
           :border (str "1px solid " (hsl 0 0 100)),
           :border-radius "8px"}}))

(defcomp
 comp-leaf
 (text)
 (div
  {:style {:display :inline-block,
           :padding "0 4px",
           :background-color (hsl 0 0 20),
           :border-radius "4px",
           :font-size 14,
           :line-height "24px",
           :margin "2px"}}
  (<> text)))

(defcomp
 comp-expr-vertical
 (expr)
 (list->
  {:style (merge
           ui/column
           {:border-left (str "1px solid " (hsl 0 0 30)), :padding-left 3}
           (if (vector? (first expr)) {:padding-top 32}))}
  (->> expr
       (map-indexed
        (fn [idx child]
          [idx
           (cond
             (string? child) (div {} (comp-leaf child))
             (empty? child) (comp-empty)
             :else (comp-expr-horizontal child))])))))

(defcomp
 comp-expr-horizontal
 (expr)
 (list->
  {:style (merge
           ui/row
           {:font-family ui/font-code,
            :border-top (str "1px solid " (hsl 0 0 20)),
            :padding-top 4}
           (if (vector? (first expr)) {:padding-left 32}))}
  (->> expr
       (map-indexed
        (fn [idx child]
          [idx
           (cond
             (string? child) (div {} (comp-leaf child))
             (empty? child) (comp-empty)
             :else (comp-expr-vertical child))])))))
