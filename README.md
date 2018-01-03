Why create services instead of cronjobs?
well of you have your cron setup with 10 different tasks, all the tasks will fail if cron fails.
Cronjobs only work setting timers och reboot, while services can be configurated to start when for example network is up och apache is running and therfore lowering the risks on fails with scripts.
