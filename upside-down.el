;;; upside-down.el --- Turns text upside down

;; Copyright (C) 2009  Rudi Schlatte

;; Author: Rudi Schlatte <rudi@constantly.at>
;; Keywords: games

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Turns text upside down, using unicode symbols similar to
;; upside-down (European) letters.

;; Mapping table courtesy of
;; http://www.fileformat.info/convert/text/upside-down.htm, which
;; credits http://www.revfad.com/flip.html.

;;; Todo:

;; - Since a major predicted use area of this functionality is
;;   comments, it would be nice to handle `comment-start-skip' and
;;   `comment-end-skip'.

;; - Perhaps offer to reverse lines as well, and have a command
;;   upside-down-buffer?

;;; Code:

(require 'cl)

(defvar upside-down-translation-alist
  '((?! . ?¡)
    (?\" . ?„)
    (?& . ?⅋)
    (?' . ?,)
    (?\( . ?\))
    (?. . ?˙)
    (?3 . ?Ɛ)
    (?4 . ?ᔭ)
    (?6 . ?9)
    (?7 . ?Ɫ)
    (?\; . ?؛)
    (?< . ?>)
    (?? . ?¿)
    (?A . ?∀)
    (?B . ?𐐒)
    (?C . ?Ↄ)
    (?D . ?◖)
    (?E . ?Ǝ)
    (?F . ?Ⅎ)
    (?G . ?⅁)
    (?J . ?ſ)
    (?K . ?⋊)
    (?L . ?⅂)
    (?M . ?W)
    (?N . ?ᴎ)
    (?P . ?Ԁ)
    (?Q . ?Ό)
    (?R . ?ᴚ)
    (?T . ?⊥)
    (?U . ?∩)
    (?V . ?ᴧ)
    (?W. ?M)
    (?Y . ?⅄)
    (?\[ . ?\])
    (?_ . ?‾)
    (?a . ?ɐ)
    (?b . ?q)
    (?c . ?ɔ)
    (?d . ?p)
    (?e . ?ǝ)
    (?f . ?ɟ)
    (?g . ?ƃ)
    (?h . ?ɥ)
    (?i . ?ı)
    (?j . ?ɾ)
    (?k . ?ʞ)
    (?l . ?ʃ)
    (?m . ?ɯ)
    (?n . ?u)
    (?r . ?ɹ)
    (?t . ?ʇ)
    (?v . ?ʌ)
    (?w . ?ʍ)
    (?y . ?ʎ)
    (?\{ . ?\})
    (?‿ . ?⁀)
    (?⁅ . ?⁆)
    (?∴ . ?∵)))

(defvar upside-down-chartable
  (let ((table (make-char-table 'translation-table)))
    (dolist (elt upside-down-translation-alist)
      (let ((from (car elt)) (to (cdr elt)))
	(aset table from to)
	(aset table to from)))
    table)
  "Upside-down character translation table.")

(defun upside-down-reverse-lines-in-string (string)
  (loop
   with string = (copy-seq string)
   for start = 0 then (if end (1+ end) nil)
   for end = (position ?\n string :start start)
   while start
   do (setf string
	    (replace string
		     (nreverse (string-to-list (subseq string start end)))
		     :start1 start :end1 end))
   finally (return string)))

(defun upside-down-region (start end)
  "Turns text in region upside down."
  (interactive "r")
  (save-excursion
    (translate-region start end upside-down-chartable)
    (insert (upside-down-reverse-lines-in-string
	     (delete-and-extract-region start end)))))

(provide 'upside-down)
;;; upside-down.el ends here
