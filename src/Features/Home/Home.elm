module Features.Home.Home exposing (home)

import Css
import Browser
import Html.Styled exposing (h2, div, text, Html)
import Html.Styled.Attributes exposing (css)

import Components.Card exposing (card)
import Core.Model.Types exposing (Model)
import Core.Message exposing (Message(..))
import Model.PostMeta.Types exposing (PostMeta)
import Components.Button exposing (button)
import Features.Home.Constants exposing (constants)
import Features.Home.Model.Query exposing (parseHomeFeatureContent)
import Features.Home.AuthorAbout exposing (authorAbout)

loadMoreButton : Model -> Html Message
loadMoreButton model =
  button
    { text = "Go to blog"
    , model = model
    , onClick = MessageLinkClicked (Browser.External "/#/blog")
    }

postsHeader : Html Message
postsHeader = h2 [ css [ Css.marginBottom <| Css.px 50 ] ] [ text "Some blog posts..." ]

postsFooter : Model -> List PostMeta -> Html Message
postsFooter model content =
  let
    shouldShowLoadMoreButton = getShouldShowLoadMoreButton content
  in
    div
      [ css
          [ Css.displayFlex
          , Css.justifyContent Css.center
          , Css.marginTop <| Css.px 30
          ]
      ]
      [ if (shouldShowLoadMoreButton) then loadMoreButton model else (div [] []) ]

post : Model -> PostMeta -> Html Message
post model postMeta =
  card
    { title = postMeta.title
    , description = postMeta.description
    , coverSrc = postMeta.cover
    , css = [ Css.marginBottom (Css.px 30) ]
    , to = "/#/posts/" ++ (String.replace ".md" "" postMeta.name)
    , theme = model.theme
    }

posts : Model -> List PostMeta -> Html Message
posts model limitedContent =
  div
    [ css
        [ Css.displayFlex
        , Css.flexWrap Css.wrap
        , Css.justifyContent Css.spaceBetween
        , Css.margin2 Css.zero Css.auto
        , Css.maxWidth (Css.px 1000)
        ]
    ]
    ( List.map (post model) limitedContent )

getShouldShowLoadMoreButton : List PostMeta -> Bool
getShouldShowLoadMoreButton content = List.length content > constants.blogPostsLimit

home : Model -> Html Message
home model =
  let
    content = parseHomeFeatureContent model.featureData.content
    limitedContent = List.take constants.blogPostsLimit content
  in
    div
      []
      [ postsHeader
      , posts model limitedContent
      , postsFooter model content
      , authorAbout model
      ]
