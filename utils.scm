;;; Copyright © 2018-2021 David Thompson <davet@gnu.org>
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

(define-module (utils)
  #:use-module (ice-9 rdelim)
  #:use-module (haunt artifact)
  #:use-module (haunt page)
  #:use-module (haunt builder blog)
  #:use-module (haunt html)
  #:use-module (haunt post)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-19)
  #:use-module (theme)
  #:export (date
            stylesheet
            script-js
            anchor
            codeblock
            link
            centered-image
            raw-snippet
            endnote
            static-page
            %cc-by-sa-button
            %cc-by-sa-link
            first-paragraph)
  #:replace (link))

(define (date year month day)
  "Create a SRFI-19 date for the given YEAR, MONTH, DAY"
  (let ((tzoffset (tm:gmtoff (localtime (time-second (current-time))))))
    (make-date 0 0 0 0 day month year tzoffset)))

(define (stylesheet name)
  `(link (@ (rel "stylesheet")
            (href ,(string-append "/css/" name ".css")))))

(define (script-js name)
  `(script (@ (src ,(string-append "/js/" name ".js")))))

(define* (anchor content #:optional (uri content))
  `(a (@ (href ,uri)) ,content))

(define (link name uri)
  `(a (@ (href ,uri)) ,name))

(define* (centered-image url #:optional alt)
  `(img (@ (class "centered-image")
           (src ,url)
           ,@(if alt
                 `((alt ,alt))
                 '()))))

(define (raw-snippet code)
  `(pre (code ,(if (string? code) code (read-string code)))))

(define (codeblock lang
                   code)
  `(pre
    (@ (class "line-numbers"))
    (code
     (@ (class
          ,(string-append "language-"
                          lang
                          " match-braces")))
     ,(if (string? code)
          code
          (read-string code)))))
(define (endnote num)
  `(sup (a
         (@
          (href ,(string-append "#en" (number->string num)))
          (id ,(string-append "r" (number->string num))))
         ,(string-append "[" (number->string num) "]"))))

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

(define (static-page title file-name body)
  (lambda (site posts)
    (make-page file-name
               (with-layout yewscion-theme site title body)
               sxml->html)))
;; Working on Rewrite using Artifacts instead of pages, not working yet.
;; (define (static-page title file-name body)
;;   (serialized-artifact file-name body
;;                        (lambda (site posts)
;;                          (with-layout yewscion-theme title body)
;;                          sxml->html)))
