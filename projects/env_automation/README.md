## How to Deploy

### Check your AWS Accout

```sh
aws sts get-caller-identity
```

### Run Deploy Script
```sh
cd projects/env_automation
chmod u+x ./bin/deploy
./bin/deploy
```

> You only have to chmod the file once to make it executable