(in-package #:graph-utils)

(defun run-tests ()
  (let ((graph (parse-pajek "data/flow1.net"))
        (bgraph (parse-pajek "data/bipartite1.net"))
        (results nil))
    (dolist (alg '(:edmond-karp :dinic :karzanov))
      (let ((f (compute-maximum-flow graph 0 5 :algorithm alg)))
        (dbg "graph flow1: ~A says flow is ~D" alg f)
        (push (list alg f) results))
      (multiple-value-bind (p1 p2) (bipartite? bgraph :show-partitions? t)
        (let ((matching
               (if (every #'evenp p1)
                   (compute-maximum-matching bgraph p1 p2 :algorithm alg)
                   (compute-maximum-matching bgraph p2 p1 :algorithm alg))))
          (dbg "graph bipartite1: ~A says matching is~% ~A"
               alg (sort matching #'< :key 'first))
          (push (list alg (sort matching #'< :key 'first)) results))))
    results))