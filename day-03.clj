; Advent of Code 2022 day 3, with Clojure
; try this at https://tio.run/#clojure

(require `clojure.set)

; split a rucksack into two halves representing its compartments
(defn compartmentalise [rucksack]
    (split-at (quot (count rucksack) 2) rucksack))

; partition a list of rucksacks into groups of 3
(defn groupify [rucksacks]
    (partition 3 rucksacks))

; turns a character into an integer 'priority' (I wonder why Clojure doesn't have isLower...)
(defn prioritise [item]
    (let [value   (int item)
          lower   (int \a)
          upper   (int \A)]
    (cond
		(>= value lower) (+ 1 (- value lower))
		:else            (+ 27 (- value upper))
	)))

; takes compartments/groups of rucksacks, turns them into sets (only unique elements matter),
; finds the element in both (or all three), gets the priority, and adds them all up!
(defn reorganise [contents]
    (->> contents
        (map (fn [x] (map set x)))
        (map (fn [x] (apply clojure.set/intersection x)))
        (map (comp prioritise first vec))
        (reduce +)))

; slurp is such a great name...
(let [lines (clojure.string/split-lines (slurp *in*))]
    (println "Sum of priorities for misplaced items:" (reorganise (map compartmentalise lines)))
    (println "Sum of priorities for unstickered badges:" (reorganise (groupify lines))))