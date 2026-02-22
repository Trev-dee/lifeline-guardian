;; ============================================================
;; Contract: lifeline-guardian.clar
;; Purpose : On-chain dead-man switch with inactivity trigger
;; ============================================================

;; -------------------------
;; ERRORS
;; -------------------------
(define-constant ERR-NOT-OWNER        (err u8001))
(define-constant ERR-NOT-ACTIVE       (err u8002))
(define-constant ERR-TOO-EARLY        (err u8003))

;; -------------------------
;; STATE
;; -------------------------

(define-data-var contract-owner principal tx-sender)
(define-data-var last-checkin uint u0)
(define-data-var timeout uint u0)
(define-data-var beneficiary principal tx-sender)
(define-data-var active bool false)

;; -------------------------
;; INITIALIZATION
;; -------------------------

(define-public (initialize
  (checkin-timeout uint)
  (recovery principal)
)
  (begin
    (asserts! (> checkin-timeout u0) ERR-TOO-EARLY)
    (asserts! (not (is-eq recovery 'SP000000000000000000002Q6VF78)) ERR-NOT-OWNER)
    (var-set contract-owner tx-sender)
    (var-set timeout checkin-timeout)
    (var-set beneficiary recovery)
    (var-set last-checkin burn-block-height)
    (var-set active true)

    (ok true)
  )
)

;; -------------------------
;; OWNER CHECK-IN
;; -------------------------

(define-public (check-in)
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-OWNER)
    (asserts! (var-get active) ERR-NOT-ACTIVE)

    (var-set last-checkin burn-block-height)
    (ok true)
  )
)

;; -------------------------
;; TRIGGER DEAD-MAN ACTION
;; -------------------------

(define-public (trigger)
  (let (
        (last (var-get last-checkin))
        (limit (var-get timeout))
       )
    (begin
      (asserts! (var-get active) ERR-NOT-ACTIVE)

      (asserts!
        (>= (- burn-block-height last) limit)
        ERR-TOO-EARLY
      )

      ;; deactivate the switch
      (var-set active false)

      ;; placeholder for asset transfer or unlock logic
      ;; example use:
      ;; beneficiary can now claim assets held elsewhere

      (ok (var-get beneficiary))
    )
  )
)

;; -------------------------
;; READ-ONLY HELPERS
;; -------------------------

(define-read-only (status)
  {
    active: (var-get active),
    last-checkin: (var-get last-checkin),
    timeout: (var-get timeout),
    beneficiary: (var-get beneficiary)
  }
)

(define-read-only (expired?)
  (and
    (var-get active)
    (>= (- burn-block-height (var-get last-checkin))
        (var-get timeout))
  )
)
