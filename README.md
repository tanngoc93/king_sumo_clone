# README

## Code Status

[![CircleCI](https://circleci.com/gh/tanngoc93/king_sumo_clone.svg?style=shield)](https://circleci.com/gh/tanngoc93/king_sumo_clone/tree/master) [![codecov](https://codecov.io/gh/tanngoc93/king_sumo_clone/branch/master/graph/badge.svg)](https://codecov.io/gh/tanngoc93/king_sumo_clone)

#### This site is a copy from [KingSumo](https://kingsumo.com/)
#### Beta version is deployed on Docker Swarm & using Traefik as a Proxy gateway, you can access [https://app.markiee.co/](https://app.markiee.co/)
#### [ERD!](https://github.com/tanngoc93/king_sumo_clone/blob/main/erd.pdf)

#### Functions Includes: Allowing customers to register and create a Giveaway campaign, embed Giveaway campaign Iframe into any website, Integrate this app to Shopify store, Send confirmation email to contestant. Contestants can earn extra points by doing actions like sharing the campaign to friends, referring new entrants through their referral code, etc

#### It's an unpublish app on Shopify. So you only can install this app with a Shopify's developing store!!!

* Ruby 3.x.x
* Rails 7.x.x
* PostgreSQL > 10.x.x
* Redis & Sidekiq for background jobs
* Docker & Docker Compose latest version

#### Build & run app with Docker

* How to build
```html
docker-compose build 
```

* How to run
```html
docker-compose up
```
