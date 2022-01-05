(use-modules (haunt asset)
             (haunt builder blog)
             (haunt builder atom)
             (haunt builder assets)
             (haunt reader)
             (haunt reader commonmark)
             (haunt post)
             (haunt site)
             (theme)
             (utils))

(define about-page
  (static-page
   "About Me"
   "about.html"
   `((h2 "Hey there!")
     (p "I am a free software advocate, an IT professional, and lover of non-C-like programming languages. I'm also an avid gamer, musician, reader, and cook.")
     (p "I support trans rights, and all of LGBTQIA2+. I am a feminist. Black Lives Matter. These are not negotiable items of my personality.")
     (p "I oppose the metaverse, cryptocurrency, MRAs, fascism, bigots, and proprietary software. I have no interest in talking about these things, and I'm not looking to debate my views on them.")
     (p "If you're into social media, you can follow me on "
        ,(anchor "Mastodon" "https://tech.lgbt/@yewscion") "."))))

(site #:title "Yewscion"
      #:domain "yewscion.com"
      #:default-metadata
      '((author . "Christopher Rodriguez")
        (email  . "yewscion@gmail.com"))
      #:readers (list commonmark-reader sxml-reader)
      #:builders (list (blog #:theme yewscion-theme)
                       (atom-feed)
                       (atom-feeds-by-tag)
                       about-page                      
                       (static-directory "css")
                       (static-directory "js")
                       (static-directory "code")))

