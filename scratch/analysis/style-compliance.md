# OpenStack AI Style Guide Compliance

## Quick Rules Checklist
- [ ] Apache 2.0 license headers in all new files
- [ ] 79 character line limit (strict)
- [ ] No bare except statements
- [ ] autospec=True in all mock.patch decorators
- [ ] Delayed logging (no f-strings in log messages)
- [ ] Proper import ordering (stdlib, third-party, local)
- [ ] AI attribution in commit messages

## Common Compliance Issues
*To be documented as encountered*

## Style Guide Reference
Primary: `refernce/openstack-ai-style-guide/docs/quick-rules.md`
Detailed: `refernce/openstack-ai-style-guide/docs/comprehensive-guide.md`

## Verification Commands
```bash
cd grian-ui
tox -e pep8
```
