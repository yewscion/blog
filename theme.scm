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
  #:export (yewscion-theme
            static-page
            project-page))

(define %cc-by-sa-link
  '(a (@ (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      "Creative Commons Attribution Share-Alike 4.0 International"))

(define %cc-by-sa-button
  '(a (@ (class "cc-button")
         (href "https://creativecommons.org/licenses/by-sa/4.0/"))
      (span (@ (class "fab fa-creative-commons") (style "color: black;") (title "Creative Commons")))
      (span (@ (class "fab fa-creative-commons-by") (style "color: black;") (title "Attribution")))
      (span (@ (class "fab fa-creative-commons-sa") (style "color: black;") (title "Share-Alike")))))

(define (first-paragraph post)
  (let loop ((sxml (post-sxml post))
             (result '()))
    (match sxml
      (() (reverse result))
      ((or (('p ...) _ ...) (paragraph _ ...))
       (reverse (cons paragraph result)))
      ((head . tail)
       (loop tail (cons head result))))))

(define yewscion-theme
  (theme #:name "yewscion"
         #:layout
         (lambda (site title body)
           `((doctype "html")
             (head
              (meta (@ (charset "utf-8")))
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
              (footer (@ (class "text-center"))
                      (p (@ (class "copyright"))
                         "© 2022 Christopher Rodriguez "
                         ,%cc-by-sa-button)
                      (p "The text and images on this site are
free culture works available under the " ,%cc-by-sa-link " license.")
                      (p "This website is built with "
                         (a (@ (href "https://dthompson.us/projects/haunt.html"))
                            "Haunt")
                         ", a static site generator written in "
                         (a (@ (href "https://gnu.org/software/guile"))
                            "Guile Scheme")
                         ".")))
             ,(script-js "prism")
             (script (@ (src "https://kit.fontawesome.com/362bd4fa7d.js") (cross-origin "anonymous")))))
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
              (p
               ,(post-ref post 'tags))
              )))
         #:collection-template
         (lambda (site title posts prefix)
           (define (post-uri post)
             (string-append "/" (or prefix "")
                            (site-post-slug site post) ".html"))

           `((h1 ,title " "
                 (a (@ (href "/feed.xml"))
                    (span (@ (class "fas fa-rss-square") (style "color: black; font-size: 1rem;") (title "RSS Feed")))))
             ,(map (lambda (post)
                     (let ((uri (string-append "/"
                                               (site-post-slug site post)
                                               ".html")))
                       `(div (@ (class "summary"))
                             (h2 (a (@ (href ,uri))
                                    ,(post-ref post 'title)))
                             (div (@ (class "date"))
                                  ,(date->string (post-date post)
                                                 "~B ~d, ~Y"))
                             (div (@ (class "post"))
                                  ,(first-paragraph post))
                             (a (@ (href ,uri)) "read more ➔"))))
                   posts)))))

(define (static-page title file-name body)
  (lambda (site posts)
    (make-page file-name
               (with-layout yewscion-theme site title body)
               sxml->html)))

;; (define* (project-page #:key name file-name description usage requirements
;;                        installation manual? license repo releases guix-package
;;                        (irc-channel "#guile"))
;;   (define (tarball-url version)
;;     (string-append "https://files.dthompson.us/"
;;                    repo "/" repo "-" version
;;                    ".tar.gz"))
;;   (define body
;;     `((h1 ,name)
;;       ,description
;;       ,@(if usage
;;             `((h2 "Usage")
;;               ,usage)
;;             '())
;;       ,@(if manual?
;;          `((h2 "Documentation")
;;            (p ,(anchor "View the reference manual"
;;                        (string-append "/manuals/" repo "/index.html"))))
;;          '())
;;       (h2 "Releases")
;;       (ul ,(map (match-lambda
;;                   ((version date)
;;                    (let ((url (tarball-url version)))
;;                      `(li ,(date->string date "~Y-~m-~d")
;;                           " — " ,version " — "
;;                           ,(anchor (string-append repo "-" version ".tar.gz")
;;                                    url)
;;                           " — "
;;                           ,(anchor "GPG signature"
;;                                    (string-append url ".asc"))))))
;;                 releases))
;;       (h2 "Requirements")
;;       (ul ,(map (lambda (requirement)
;;                   `(li ,requirement))
;;                 requirements))
;;       (h2 "Installation")
;;       ,@(if installation
;;             (list installation)
;;             (match (car releases)
;;               ((version _)
;;                `(,@(if guix-package
;;                        `((p "To install " ,name " with the GNU Guix package manager, run:")
;;                          (pre "guix install " ,guix-package))
;;                        '())
;;                  (p "To build and install " ,name " from source, run:")
;;                  (pre "wget "
;;                       ,(tarball-url version)
;;                       "
;; tar xf "
;;                       ,repo "-" ,version ".tar.gz"
;;                       "
;; cd "
;;                       ,repo "-" ,version
;;                       "
;; ./configure
;; make
;; make install")))))
;;       (h2 "License")
;;       (p ,license)
;;       (h2 "Git Repository")
;;       ,@(let ((url (string-append "https://git.dthompson.us/" repo ".git")))
;;           `((p ,name " is developed using the Git version control
;; system. The official repository is hosted at "
;;                ,(anchor url url) ".")
;;             (p "To clone the repository, run:")
;;             (pre "git clone " ,url)))
;;       (h2 "Community")
;;       (p "Real-time discussion for " ,name " can be found on the "
;;          (code ,irc-channel)
;;          " channel on the "
;;          ,(anchor "Libera.chat" "https://libera.chat")
;;          " IRC network")
;;       (h2 "Contributing")
;;       (p "Send patches and bug reports to "
;;          ,(anchor "davet@gnu.org" "mailto:davet@gnu.org")
;;          ".")))

;;   (static-page name (string-append "projects/" file-name) body))
