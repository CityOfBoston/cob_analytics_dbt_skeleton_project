*Note urgency/priority and deadline for PR to be reviewed if urgent*

Jira Ticket:
- link

Related PRs:
- link

## Summary

Summary of changes implemented by this PR.

- list out
- specific changes

## Due diligence checks

*Please check if applicable and performed successfully*

- [ ] I successfully ran `dbt build --select +new_models+ +updated_models+` for any new models or updated models
- [ ] New models or updated models were successfully created in the _dev environment
- [ ] I have added high-importance tests to any new sources (freshness, primary key, at least 1 record, etc)
- [ ] I have reviewed the test results and affirm that any test failures should be failures
- [ ] I have added or updated exposures for known downstream dependencies
- [ ] I have added documentation to sources, including descriptions and metadata (with `meta:`)
- [ ] I have previewed the changes to the docs site (run locally `dbt docs generate` and then `dbt docs serve`)

### Caveats

Please note any caveats regarding the due diligence checks here if applicable