
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     For use with the Auto Demo Example
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

;; this UI-state is an object to display in winform
;; deftemplate is a list of named fields called slots. Deftemplate allows access by name rather than
;; by specifying the order of fields.
;; slot like the column of a table
(deftemplate UI-state
   (slot id (default-dynamic (gensym*))); the gensym* is to generate a unique id
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (multislot games)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

;; ask the first question (TimeQuestion) to check whether is a hardcore player
(defrule determine-hardcore-player ""

   (logical (start))

   =>

   (assert (UI-state (display TimeQuestion)
                     (relation-asserted hardcore-player)
                     (response No)
                     (valid-answers Yes No))))

;; ask the second question (HCMoneyQuestion) to check whether is a money player  
(defrule determine-money-player ""

   (logical (hardcore-player Yes))

   =>

   (assert (UI-state (display HCMoneyQuestion)
                     (relation-asserted money-player)
                     (response No)
                     (valid-answers No Yes))))

;; ask the second question (MoneyQuestion) to check how much money would like to pay 
(defrule determine-budget ""

   (logical (hardcore-player No))

   =>

   (assert (UI-state (display MoneyQuestion)
                     (relation-asserted kids-player)
                     (response No)
                     (valid-answers No Yes))))

;; ask the third question (MatureQuestion) to check whether all games can be played    
(defrule determine-kids-or-not ""

   (logical (money-player No))

   =>

   (assert (UI-state (display MatureQuestion)
                     (relation-asserted kids-player)
                     (response No)
                     (valid-answers No Yes))))

;; ask the fourth question (DeviceQuestion) to check which device preferred.
(defrule determine-platform-preference ""

   (logical (kids-player No))

   =>

   (assert (UI-state (display DeviceQuestion)
                     (relation-asserted device-prefer)
                     (response No)
                     (valid-answers PC Mobile))))

;; ask the fifth question (CateQuestion) to check which category preferred.
(defrule determine-category-preference ""

   (logical (device-prefer PC))

   =>

   (assert (UI-state (display CateQuestion)
                     (relation-asserted casual-recommend)
                     (response No)
                     (valid-answers Action Strategy RPG))))

;; if harcore-player, money-player and not kids
;; will recommend some best rating not consider the cost games
(defrule determine-gas-level ""

   (logical (hardcore-player Yes)

			(money-player Yes)

            (kids-player No))

   =>
   ;; for this category will remove the kids kind and focus on the categories loved by the hardcore players
   (assert (UI-state (display CateQuestion)
                     (relation-asserted hardcore-recommend)
                     (response No)
                     (valid-answers Action Strategy RPG))))



;;;****************
;;;* RECOMMEND RULES *
;;;****************

(defrule hardcore-player-recommend-conclusions ""

   (logical (hardcore-recommend Action))
   
   =>

   (assert (UI-state (display HardcoreActionRecommend)
					 (games "Call of Duty" "Far Cry 4" "Grand Theft Auto V")
                     (state final))))

(defrule casual-player ""

   (logical (casual-recommend Strategy))
   
   =>

   (assert (UI-state (display CasualStrategyRecommend)
					 (games "Clash of Clans" "Top 11" "Angry Birds")
                     (state final))))

;; below didn't modify as not understand yet.                    
;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
