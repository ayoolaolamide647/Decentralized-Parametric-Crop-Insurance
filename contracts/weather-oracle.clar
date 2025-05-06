;; Weather Data Oracle Contract
;; Tracks environmental conditions

;; Data Maps
(define-map weather-data
  { location: (string-ascii 100), timestamp: uint }
  {
    temperature: int,
    rainfall: uint,
    humidity: uint,
    wind-speed: uint,
    reported-by: principal,
    report-time: uint
  }
)

(define-map oracle-providers
  { provider: principal }
  {
    name: (string-ascii 100),
    active: bool,
    registration-date: uint
  }
)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-not-registered (err u101))

;; Read-only functions
(define-read-only (get-weather-data (location (string-ascii 100)) (timestamp uint))
  (map-get? weather-data { location: location, timestamp: timestamp })
)

(define-read-only (get-oracle-provider (provider principal))
  (map-get? oracle-providers { provider: provider })
)

(define-read-only (is-active-provider (provider principal))
  (default-to false (get active (get-oracle-provider provider)))
)

;; Public functions
(define-public (register-oracle-provider (name (string-ascii 100)))
  (begin
    ;; Only contract owner can register providers
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)

    ;; Register the provider
    (map-set oracle-providers
      { provider: tx-sender }
      {
        name: name,
        active: true,
        registration-date: block-height
      }
    )

    (ok true)
  )
)

(define-public (deactivate-provider (provider principal))
  (let (
    (oracle-provider (unwrap! (get-oracle-provider provider) err-not-registered))
  )
    ;; Only contract owner can deactivate providers
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)

    ;; Deactivate the provider
    (map-set oracle-providers
      { provider: provider }
      (merge oracle-provider { active: false })
    )

    (ok true)
  )
)

(define-public (report-weather-data
    (location (string-ascii 100))
    (timestamp uint)
    (temperature int)
    (rainfall uint)
    (humidity uint)
    (wind-speed uint))
  (begin
    ;; Check if provider is active
    (asserts! (is-active-provider tx-sender) err-not-registered)

    ;; Store weather data
    (map-set weather-data
      { location: location, timestamp: timestamp }
      {
        temperature: temperature,
        rainfall: rainfall,
        humidity: humidity,
        wind-speed: wind-speed,
        reported-by: tx-sender,
        report-time: block-height
      }
    )

    (ok true)
  )
)

;; Get average rainfall for a location over a period
(define-read-only (get-rainfall-data
    (location (string-ascii 100))
    (start-time uint)
    (end-time uint))
  ;; Note: In a real implementation, this would need to iterate through all data points
  ;; and calculate the average. For simplicity, we're just returning a placeholder.
  ;; In production, you would use a more sophisticated approach or off-chain indexing.
  (ok u0)
)

;; Get extreme temperature events for a location over a period
(define-read-only (get-temperature-extremes
    (location (string-ascii 100))
    (start-time uint)
    (end-time uint))
  ;; Similar to above, this is a placeholder
  (ok { min: (to-int u0), max: (to-int u0) })
)
