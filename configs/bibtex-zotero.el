(defun helm-bibtex-open-in-zotero ()
  "Open the citation entry in Zotero."
  (interactive)
  (let* ((key (car (org-ref-get-bibtex-key-and-file)))
         (url (bibtex-completion-get-value "file" (bibtex-completion-get-entry key)))
         (valid (string-prefix-p "zotero://" url)))
    (if valid
        (browse-url url))))

;; BibTex
  (setq bibtex-completion-bibliography "~/Documents/Zotero/Zotero.bib")
  (defhydra+ org-ref-citation-hydra ()
    ("z" helm-bibtex-open-in-zotero "Zotero" :column "Open"))
