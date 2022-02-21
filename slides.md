---
title: Serverless Architecture for IoT on AWS
theme: white
slideNumber: true
header-includes: |
  <link href="https://fonts.googleapis.com/css2?family=Work+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
   .reveal h1, .reveal h2, .reveal h3, .reveal h4, .reveal h5, .reveal h6 {
      font-weight: 300;
      text-transform: none;
      font-family: var(--heading-font);
      color: #00a9ce;
   } 
   .reveal {
        font-size: var(--main-font-size);
        font-family: var(--main-font); 
        font-weight: 400;
        font-size: 32px;
        margin-top: 42px;
        height: calc(100% - 42px);
   }
   .reveal strong {
        font-weight: 500;
   }
   .reveal a {
      color: #00a9ce;
   }
   .reveal ul {
     list-style-type: square;
     list-style-color: #00a9ce;
   }
   .reveal li::marker {
     color: #00a9ce;
   }
   :root {
        --main-font: 'Work Sans', sans-serif;
       --heading-font: 'Work Sans', sans-serif;
   }
   .reveal-viewport {
     background-color: #fff;
   }
   .reveal-viewport::before {
      content: "© Nordic Semiconductor | CC-BY-NC-SA-4.0";
      position: absolute;
      top: 0; 
      left: 0;
      width: 100%; 
      height: 42px;
      background-color: #00a9ce;
      color: white;
      font-family: var(--main-font);
      font-size: 14px;
      font-weight: bold;
      line-height: 42px;
      padding-left: 10vw;
   }
   #about-me img {
      border-radius: 100%;
    }
    #about-me ul {
      font-size: 80%;
      margin-top: 6rem;
    }
    #about-me div.column:first-child {
      text-align: center;
    }
    .slide-background:first-child .slide-background-content {
      background-image: url('./titlebg.png');
      
    }
    #title-slide h1 {
      color: white;
      font-weight: 500;
      font-size: 60px;
    }
    #title-slide h1:after {
      content: "IDG2001 | Cloud Technologies | NTNU";
      display: block;
      color: #222;
      background-color: white;
      padding: 1rem;
      margin-top: 2rem;
      font-weight: 300;
      font-size: 32px;
    }
    #title-slide:after {
      content: "February 2022";
      font-size: 22px;
      color: white;
      font-style: italic;
    }
    figcaption {
      display: none;
    }
    div.column {
      text-align: left;
      width: calc(50% - 1rem); 
      margin-right: 1rem;
    }
    div.column + div.column {
      margin-left: 1rem;
      margin-right: 0;
    }
  </style>
---

## About me

:::::::::::::: {.columns}

::: {.column}

![Markus Tacker](./markus.jpg){width=35%}

Markus Tacker

**Senior R&D Engineer**

<small>[Markus.Tacker@NordicSemi.no](mailto:Markus.Tacker@NordicSemi.no)  
Twitter: [\@coderbyheart](https://twitter.com/coderbyheart)  
[coderbyheart.com](https://coderbyheart.com)</small>

:::

::: {.column}

- 1980: Born in Germany (Xennial)
- 1998: first business building websites
- 2003: Mediengestalter für Digital- und Printmedien, Fachrichtung
  Medienoperating nonprint
- 2012: B.Sc. Computer Science (Univ. Wiesbaden)
- 2017+: in Trondheim, at [Nordic Semiconductor](https://www.nordicsemi.com/)

:::

::::::::::::::

## My work at Nordic Semiconductor

**2017**

First full time cloud engineer working on [nrfcloud.com](https://nrfcloud.com/)
building Software-as-a-service (Saas) offering.

**2019**

Application Group to work on on open-source end-to-end examples of real world
IoT products.

## Agenda

- Why _serverless_?
- Scenario overview
- Amazon Web Services (AWS) implementation

## What is _serverless_?

_Serverless computing allows me to focus on implementing the solution, and not
spend time on maintaining the infrastructure needed to execute it._

More detailed analysis:
[martinfowler.com/articles/serverless.html](https://martinfowler.com/articles/serverless.html)

## Why I like serverless

- build globally scalable solutions with a small team
- suprises are rare, allows me to go on vacation

:::notes

Going serverless allows me and a rather small team of engineers to build a
globally scalable software solution with a very high confidence in it's
scalability and an ease of mind during operations.

In the last years since I have been working fully serverless, I have not once
experienced a surprising event that impacted our production system.

Yes, we experience issues which gradually become more serious over time, but in
general it happens in a way that does not interfere with my vacation plans.

Serverless not only enables horizontal scalability, but allows to update each
component of the solution individually: the code for a lambda function can be
replaced without affecting other functions. This means no more waiting minutes
for a monolithic container to come up again after a fix has been deployed.

:::

## Horizontal Scalablity

- Serverless implementations depend on _stateless_, _event-driven_
  implementations.
- This allows to process as many requests as needed, in _parallel_.
- However, you have to deal with eventual consistency.

## Updating individual components

Instead of restarting the instance,  
I can update _an individual function_.

:::notes

Serverless not only enables horizontal scalability, but allows to update each
component of the solution individually: the code for a lambda function can be
replaced without affecting other functions. This means no more waiting minutes
for a monolithic container to come up again after a fix has been deployed.

:::

## Downsides of serverless

## Testability

- Testing cloud-native solutions really is a challenge.

:::notes

You can see my talk about testing cloud-native solutions here:
https://coderbyheart.com/it-does-not-run-on-my-machine/

:::

## Infrastructure is part of the solution

- More ceremony involved, defining infrastructure as code is now your job.

## Serverless is usually closed source

- Impossible to run it locally.

## Mindset shift

- Huge mindset shift from the classical application server model (LAMP, Tomcat,
  Rails), to a serverless, stateless, eventual consistent application
  development model.

## IoT <3 Serverless

## No **world**

- Many, many devices, that don't share global state.

## 18+ billion IoT devices this year

- Needs to scale to billions of devices, connections, message per day.

:::notes

https://www.ericsson.com/en/about-us/company-facts/ericsson-worldwide/india/authored-articles/ushering-in-a-better-connected-future

:::

## Data for thousands of use cases

- Many different operations with different business needs (processing) on small
  datasets, suits serverless microservice model very well.

## Architecture Example: store and retrieve temperature data

![Historical Data](./historical-data.jpg)

[miro.com/app/board/o9J_llBJjJM=](https://miro.com/app/board/o9J_llBJjJM=/)

## AWS implementation

![AWS implementation](./aws.jpg){width=80%}

## Book recommendations

- [REST in Practice](http://shop.oreilly.com/product/9780596805838.do)
- [ACCELERATE](https://itrevolution.com/book/accelerate/)

## Thank you & happy connecting!

Please share your feedback!

<small>[Markus.Tacker@NordicSemi.no](mailto:Markus.Tacker@NordicSemi.no)  
Twitter: [\@coderbyheart](https://twitter.com/coderbyheart)</small>

<small>Latest version:  
[`bit.ly/awsiotarch`](https://bit.ly/awsiotarch)</small>

We are hiring!  
[nordicsemi.com/jobs](https://nordicsemi.com/jobs)  
<small>Trondheim &middot; Oslo &middot; worldwide</small>
