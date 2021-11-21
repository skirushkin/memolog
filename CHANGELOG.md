## 0.3.0

- Apply a prepend patch with `Sentry::Scope#apply_to_event` method.
- Check constant definition via `Object.const_defined?`
- Moving `Sentry::Sidekiq` scheme to monkey patch `Sentry::Sidekiq::SentryContextServerMiddleware`
- More specs

## 0.2.2

- Do not init Rails middleware in Sidekiq server.

## 0.2.1

- Better Rails middleware initialization.

## 0.2.0

- Uprade gem due [CVE-2021-41098](https://github.com/advisories/GHSA-2rr5-8q37-2w7h)
- Add initializers config option, available initializers are [rails, sentry, sidekiq].
- Move debug option to config.

## 0.1.0

- Test version for publish and test workflow.
