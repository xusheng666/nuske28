
;;;======================================================
;;;     vGamer Recommender Expert System Part 2
;;;
;;;     This expert system recommend applicants with ask some
;;;     basic question to find a suitable game for them.
;;;
;;;     CLIPS Version 6.3
;;;
;;;     For use of the CA Project Demo
;;;	    
;;;======================================================


;;;***************
;;;* QUERY RULES *
;;;***************

;;;====================
;;; First Level of the Question of the Goal of the game
;;;====================
;; ask the first question (GoalQuestion) to check what's the goal to play game
;; divided to 4 main category (Compete, Strategize, Learn, Pass Time)
(defrule determine-goal-of-game ""

   (logical (start))

   =>

   (assert (UI-state (display GoalQuestion)
                     (relation-asserted goal-of-game)
                     (response No)
                     (valid-answers Compete Strategy Learn PassTime))))

;;;~~~~~~~~~~~~~~~~~~~~~
;;; For Compete player
;;;~~~~~~~~~~~~~~~~~~~~~
;; LEFT of the Tree
;; ask the second question (OpponentQuestion) to check which opponent you wish to play with  
(defrule determine-opponent-player ""

   (logical (goal-of-game Compete))

   =>

   (assert (UI-state (display OpponentQuestion)
                     (relation-asserted opponent-player)
                     (response No)
                     (valid-answers OtherPerson AIOrSinglePerson AgainstGameWorld))))

;; if select Other Person 
(defrule determine-social-type ""

   (logical (opponent-player OtherPerson))

   =>

   (assert (UI-state (display SocialTypeQuestion)
                     (relation-asserted social-type)
                     (response No)
                     (valid-answers Team_Based OpenWorld CompeteWithOtherPlayers))))


;; if select Team Based 
(defrule determine-mechanic-type ""

   (logical (social-type Team_Based))

   =>

   (assert (UI-state (display MechanicQuestion)
                     (relation-asserted mechanic-type)
                     (response No)
                     (valid-answers Eliminate DestroyBase))))

;; if select AIOrSinglePerson 
(defrule determine-pace-type ""

   (logical (opponent-player AIOrSinglePerson))

   =>

   (assert (UI-state (display PaceQuestion)
                     (relation-asserted q1r2l-pace-type)
                     (response No)
                     (valid-answers FastRealTime TurnBased))))

;; if select  FastRealTime
(defrule determine-control-type ""

   (logical (q1r2l-pace-type FastRealTime))

   =>

   (assert (UI-state (display ControlQuestion)
                     (relation-asserted q1r2l-control-type)
                     (response No)
                     (valid-answers OneCharacterOneTime GroupUnitsOneTime))))

;; if select  TurnBased
(defrule determine-perspective-type ""

   (logical (q1r2l-pace-type TurnBased))

   =>

   (assert (UI-state (display PerspectiveQuestion)
                     (relation-asserted q1r2r-control-type)
                     (response No)
                     (valid-answers Card StrategicPosition))))
;;;~~~~~~~~~~~~~~~~~~~~~
;;; For Strategized player
;;;~~~~~~~~~~~~~~~~~~~~~
;; ask the second question (FocusOnQuestion) to check how much money would like to pay 
(defrule determine-strategy ""

   (logical (goal-of-game Strategy))

   =>

   (assert (UI-state (display FocusOnQuestion)
                     (relation-asserted focus-part)
                     (response No)
                     (valid-answers "Character Growth" "Winning" "Planning and Design"))))
;;;~~~~~~~~~~~~~~~~~~~~~
;;; For Learn player
;;;~~~~~~~~~~~~~~~~~~~~~
;; ask the third question (SkillQuestion) to check whether all games can be played    
(defrule determine-skill ""

   (logical (goal-of-game Learn))

   =>

   (assert (UI-state (display SkillQuestion)
                     (relation-asserted skill-learn)
                     (response No)
                     (valid-answers "Science" "Navigation" "Architecture" "Physical" "Planning" "Rhythm"))))

;;;~~~~~~~~~~~~~~~~~~~~~
;;; For Pass time player
;;;~~~~~~~~~~~~~~~~~~~~~
;; ask the fourth question (PartnerQuestion) to check which device preferred.
(defrule determine-social-preference ""

   (logical (goal-of-game PassTime))

   =>

   (assert (UI-state (display PartnerQuestion)
                     (relation-asserted social-prefer)
                     (response No)
                     (valid-answers Yes No))))

;;;~~~~~~~~~~~~~~~~~~~~~
;;; Common budget question before final recommend
;;;~~~~~~~~~~~~~~~~~~~~~

;; if select against the game world
(defrule determine-q1m-budget-prefer ""

   (logical (opponent-player AgainstGameWorld))

   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q1m-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-q2m-budget-prefer ""
	
   (logical (social-type OpenWorld))
   
   =>
   
   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q2m-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-budget-prefer ""
	
   (logical (social-type CompeteWithOtherPlayers))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q2r-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))
					 
(defrule determine-q3l-budget-prefer ""
	
   (logical (mechanic-type Eliminate))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q3l-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))
(defrule determine-q3r-budget-prefer ""
	
   (logical (mechanic-type DestroyBase))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q3r-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))
;;; for right hand branches

(defrule determine-q1r2ll-budget-prefer ""
	
   (logical (q1r2l-control-type OneCharacterOneTime))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q1r2ll-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-q1r2lr-budget-prefer ""
	
   (logical (q1r2l-control-type GroupUnitsOneTime))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q1r2lr-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))
					 
(defrule determine-q1r2rl-budget-prefer ""
	
   (logical (q1r2r-control-type Card))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q1r2rl-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))

(defrule determine-q1r2rr-budget-prefer ""
	
   (logical (q1r2r-control-type StrategicPosition))
   
   =>

   (assert (UI-state (display BudgetQuestion)
                     (relation-asserted q1r2rr-budget-prefer)
                     (response No)
                     (valid-answers Yes No))))					 						 					 					 	
;;;****************
;;;* RECOMMEND RULES *
;;;****************

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q2m-yes ""

   (logical (q2m-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Fallout 4 (S$50)" "Far Cry 3(S$7)")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q2m-no ""

   (logical (q2m-budget-prefer No))

   =>

	(assert (UI-state (display FinalRecommend)
					  (games "None")
                      (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q2m-yes ""

   (logical (q2m-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "World of Warcraft (S$45)" "Guild Wars 2(S$50)" "Eve Online (S$40)")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q2m-no ""

   (logical (q2m-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Rift" "Path of Exile")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q2r-yes ""

   (logical (q2r-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Need for Speed (S$10)" "Dirt Rally(S$45)" "Mario Kart (S$40)" "Sonic & All-Stars Racing(S$20)" "Rocket League(S$13)")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q2r-no ""

   (logical (q2r-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "None")
                     (state final))))

;; for question 3 left
;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q3l-no ""

   (logical (q3l-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Counter Strike" "Team Fortress" "Warframe")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q3l-yes ""

   (logical (q3l-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "ARK:Survival Evolved (S$30)")
                     (state final))))

;; for question 3 right
;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q3r-no ""

   (logical (q3r-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Dota" "League of Legends" "AirMech")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q3r-yes ""

   (logical (q3r-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "None")
                     (state final))))

;;;; for right hand final recommend

(defrule goal-of-game-recommend-conclusions-q1r2ll-yes ""

   (logical (q1r2ll-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Street Fighter 4 (S$40)" "Mortal Kombat X(S$20)" "NBA2K16 (S$80)" "Dark Souls (S$22)")
                     (state final))))
;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q1r2ll-no ""

   (logical (q1r2ll-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "None")
                     (state final))))
;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q1r2lr-yes ""

   (logical (q1r2lr-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Starcraft III (S$60)" "Sins of the Solar Empire (S$10)" "Age of Empires III(S$7)" "Total War Attila (S$12)")
                     (state final))))
;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q1r2lr-no ""

   (logical (q1r2lr-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "None")
                     (state final))))
;;;; for right hand final recommend

(defrule goal-of-game-recommend-conclusions-q1r2rl-no ""

   (logical (q1r2rl-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "Hearthstone" "Battle Hand" "Texas Holdem Poker")
                     (state final))))

(defrule goal-of-game-recommend-conclusions-q1r2rl-Yes ""

   (logical (q1r2rl-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "None")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q1r2rr-yes ""

   (logical (q1r2rr-budget-prefer Yes))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "XCOM: Enemy Unknown (S$7)" "Jagged Alliance - BIA (S$30)" "Endless Legend (S$10)")
                     (state final))))

;; if select Open World then it's MMO type of games
(defrule goal-of-game-recommend-conclusions-q1r2rr-no ""

   (logical (q1r2rr-budget-prefer No))

   =>

   (assert (UI-state (display FinalRecommend)
					 (games "ADOM" "Tales of Maj'Eyal")
                     (state final))))