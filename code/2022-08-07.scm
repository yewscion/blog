(define (get-file-as-string file)
  "Slurp the contents of a file and return them as a string.

This is an ACTION.

Arguments
=========
FILE <string>: The name of the file to slurp.

Returns
=======
A <string> representing the contents of the FILE.

Impurities
==========
Depends on the state of the FILE."
  (call-with-input-file file get-string-all))
