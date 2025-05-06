;; Farmer Verification Contract
;; This contract validates legitimate agricultural producers

;; Data Maps
(define-map farmers
  { farmer-id: (string-ascii 36) }
  {
    principal: principal,
    name: (string-ascii 100),
    location: (string-ascii 100),
    verified: bool,
    verification-date: uint
  }
)

(define-map verification-requests
  { request-id: (string-ascii 36) }
  {
    farmer-id: (string-ascii 36),
    principal: principal,
    status: (string-ascii 20),
    submission-date: uint
  }
)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-found (err u102))

;; Read-only functions
(define-read-only (get-farmer (farmer-id (string-ascii 36)))
  (map-get? farmers { farmer-id: farmer-id })
)

(define-read-only (get-verification-request (request-id (string-ascii 36)))
  (map-get? verification-requests { request-id: request-id })
)

(define-read-only (is-verified (farmer-id (string-ascii 36)))
  (default-to false (get verified (get-farmer farmer-id)))
)

;; Public functions
(define-public (submit-verification-request
    (request-id (string-ascii 36))
    (farmer-id (string-ascii 36))
    (name (string-ascii 100))
    (location (string-ascii 100)))
  (begin
    ;; Check if farmer is already verified
    (asserts! (is-none (get-farmer farmer-id)) err-already-verified)

    ;; Store verification request
    (map-set verification-requests
      { request-id: request-id }
      {
        farmer-id: farmer-id,
        principal: tx-sender,
        status: "pending",
        submission-date: block-height
      }
    )

    ;; Create farmer entry with unverified status
    (map-set farmers
      { farmer-id: farmer-id }
      {
        principal: tx-sender,
        name: name,
        location: location,
        verified: false,
        verification-date: u0
      }
    )

    (ok true)
  )
)

(define-public (approve-verification (request-id (string-ascii 36)))
  (let (
    (request (unwrap! (get-verification-request request-id) err-not-found))
    (farmer-id (get farmer-id request))
    (farmer (unwrap! (get-farmer farmer-id) err-not-found))
  )
    ;; Only contract owner can approve
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)

    ;; Update verification request status
    (map-set verification-requests
      { request-id: request-id }
      (merge request { status: "approved" })
    )

    ;; Update farmer verification status
    (map-set farmers
      { farmer-id: farmer-id }
      (merge farmer {
        verified: true,
        verification-date: block-height
      })
    )

    (ok true)
  )
)

(define-public (reject-verification (request-id (string-ascii 36)))
  (let (
    (request (unwrap! (get-verification-request request-id) err-not-found))
  )
    ;; Only contract owner can reject
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)

    ;; Update verification request status
    (map-set verification-requests
      { request-id: request-id }
      (merge request { status: "rejected" })
    )

    (ok true)
  )
)
