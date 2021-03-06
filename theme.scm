;;; Copyright © 2018-2021 David Thompson <davet@gnu.org>
;;; Copyright © 2022 Christopher Rodriguez <yewscion@gmail.com>
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; This is an edited version of the theme from David Thompson's
;;; Website, with original code and other snippets added to customize
;;; it for my (yewscion's) blog. Any code pulled from other people is
;;; under their copyright still, though any code I've written myself
;;; is under mine. All code on this website is under the AGPL 3.0+.
;;;
;;; The above message was last updated 2022-01-05.
;;;

(define-module (theme)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt page)
  #:use-module (haunt post)
  #:use-module (haunt site)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-1)
  #:use-module (utils)
  #:use-module (haunt artifact)
  #:export (yewscion-theme))

(define yewscion-theme
  (theme #:name "yewscion"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (html
              (head
               (meta (@ (charset "utf-8")))
               (link (@ (rel "apple-touch-icon")
                        (sizes "180x180")
                        (href "/apple-touch-icon.png?v=20220705")))
               (link (@ (rel "icon")
                        (type "image/png")
                        (sizes "32x32")
                        (href "/favicon-32x32.png?v=20220705")))
               (link (@ (rel "icon")
                        (type "image/png")
                        (sizes "16x16")
                        (href "/favicon-16x16.png?v=20220705")))
               (link (@ (rel "manifest")
                        (href "/site.webmanifest?v=20220705")))
               (link (@ (rel "mask-icon")
                        (href "/safari-pinned-tab.svg?v=20220705")
                        (color "#462700")))
               (link (@ (rel "shortcut icon")
                        (href "/favicon.ico?v=20220705")))
               (meta (@ (name "msapplication-TileColor")
                        (content "#000000")))
               (meta (@ (name "msapplication-TileImage")
                        (content "/mstile-144x144.png?v=20220705")))
               (meta (@ (name "theme-color")
                        (content "#462700")))
               (title ,(string-append title " — " (site-title site)))
               ,(stylesheet "normalize")
               ,(stylesheet "fonts")
               ,(stylesheet "prism")
               ,(stylesheet "yewscion"))
              (body
               (header
                (nav
                 (h1 ,(link "Yewscion" "/"))
                 (ul 
                  (li ,(link "About" "/about.html")))))
               (main
                ,body)
               (footer
                (nav
                 (ul
                  (li
                   (a (@
                       (href "https://fediring.net/previous?host=yewscion.com"))
                      (character "←"))
                   (a (@
                       (href "https://fediring.net/"))
                      "Fediring")
                   (a (@
                       (href "https://fediring.net/random"))
                      "⇄")
                   (a (@
                       (href "https://fediring.net/next?host=yewscion.com"))
                      "→"))))
                (p (@ (class "copyright"))
                   "© 2022 Christopher Rodriguez "
                   ,%cc-by-sa-button
                   " (I'm on the "
                   (a (@
                       (rel "me") (href "https://tech.lgbt/@yewscion"))
                      "Fediverse")
                   ")")
                (p "The text and images on this site are free culture "
                   "works available under the " ,%cc-by-sa-link " license.")
                (p "This website is built with "
                   (a (@
                       (href "https://dthompson.us/projects/haunt.html"))
                      "Haunt")
                   ", a static site generator written in "
                   (a (@
                       (href "https://gnu.org/software/guile"))
                      "Guile Scheme")
                   ". Background from "
                   (a (@
                       (href "https://www.svgbackgrounds.com/"))
                      "SVG Backgrounds")
                   ". Most icons are part of "
                   (a (@
                       (href "https://fontawesome.com/"))
                      "Font Awesome")
                   ". All content is written using "
                   (a (@
                       (href
                        "https://www.gnu.org/software/guile/manual/html_node/SXML.html"))
                      "SXML")
                   "."))
               ,(script-js "prism")
               (script (@
                        (src "https://kit.fontawesome.com/362bd4fa7d.js")
                        (cross-origin "anonymous")))))))
         #:post-template
         (lambda (post)
           `(article
             (header
              (h1 ,(post-ref post 'title))
              (time
               (@ (datetime
                   ,(date->string (post-date post)
                                  "~Y-~m-~d")))
               ,(date->string (post-date post)
                              "~B ~d, ~Y")))
             (main
              ,(post-sxml post))
             (footer
              (p "RSS Feeds for Tags: "
               ,(map (lambda (x)
                       `(a (@
                       (href ,(string-append "/feeds/tags/" x ".xml")))
                           ,(string-append x " ")))
                     (post-ref post 'tags)))
              )))
         #:collection-template
         (lambda (site title posts prefix)
           (define (post-uri post)
             (string-append "/" (or prefix "")
                            (site-post-slug site post) ".html"))

           `((h1 ,title " "
                 (a (@
                       (href "/feed.xml"))
                    (span (@ (class "fas fa-rss-square")
                             (style "color: black; font-size: 1rem;")
                             (title "RSS Feed")))))
             ,(map (lambda (post)
                     (let ((uri (string-append "/"
                                               (site-post-slug site post)
                                               ".html")))
                       `(div (@ (class "summary"))
                             (h2 (a (@
                       (href ,uri))
                                    ,(post-ref post 'title)))
                             (div (@ (class "date"))
                                  ,(date->string (post-date post)
                                                 "~B ~d, ~Y"))
                             (div (@ (class "post"))
                                  ,(first-paragraph post))
                             (a (@
                       (href ,uri)) "read more →"))))
                   posts)))))
