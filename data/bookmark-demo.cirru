
defcomp comp-bookmark (bookmark idx selected?)
  div
    {} (:class-name |stack-bookmark)
      :draggable true
      :on-click $ on-pick bookmark idx
      :on-dragstart $ fn (e d! m!)
        -> e :event .-dataTransfer $ .setData "\"id" idx
      :on-drop $ fn (e d! m!)
        let
            target-idx $ js/parseInt
              -> e :event .-dataTransfer $ .getData "\"id"
          when (not= target-idx idx)
            d! :writer/move-order $ {} (:from target-idx)
              :to idx
      :on-dragover $ fn (e d! m!)
        -> e :event .preventDefault
    case (:kind bookmark)
      :def $ div
        {} $ :style (merge style-bookmark)
        div ({})
          span $ {}
            :inner-text $ :extra bookmark
            :style $ merge style-main (if selected? style-highlight)
        div
          {} $ :style ui/row-middle
          =< 8 nil
          <> (:ns bookmark) style-minor
      div
        {} $ :style
          merge style-bookmark $ {} (:padding "\"8px")
        <> span
          str $ :kind bookmark
          , style-kind
        <> (:ns bookmark)
          merge style-main $ if selected? style-highlight
