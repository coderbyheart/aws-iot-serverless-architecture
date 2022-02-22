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
    .slide p {
      text-align: left;
    }
    .reveal pre {
      box-shadow: none;
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

### My work at Nordic Semiconductor

#### 2017

First full time cloud engineer working on [nrfcloud.com](https://nrfcloud.com/)
building Software-as-a-service (Saas) offering.

#### 2019

Application Group to work on on open-source end-to-end examples of real world
IoT products.

## Agenda

- What is _serverless_?
- AWS Lambda explained
- Why I like _serverless_
  - Downsides of _serverless_
- IoT <3 _serverless_
  - Architecture Example:  
    store and retrieve temperature data
- Book recommendations

## What is _serverless_?

Serverless \[architectures\] are application designs that \[...\] run in
**managed, ephemeral containers** on a “Functions as a Service” (FaaS) platform.

:::notes

Source: https://martinfowler.com/articles/serverless.html

:::

### Benefits

By using these ideas, \[...\] such architectures remove much of the need for a
traditional always-on server component.

\[They\] **may** benefit from significantly reduced operational cost,
complexity, and engineering lead time, at a cost of increased reliance on vendor
dependencies and comparatively immature supporting services.

Source:
[martinfowler.com/articles/serverless.html](https://martinfowler.com/articles/serverless.html)

## AWS Lambda explained

With [Lambda](https://aws.amazon.com/lambda/), you can run code virtually with
zero administration of the underlying infrastructure. You are responsible only
for the code that you provide Lambda, and the configuration of how Lambda runs
that code on your behalf.

:::notes

Sources for this section:

- https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
- https://docs.aws.amazon.com/whitepapers/latest/security-overview-aws-lambda/

:::

### AWS Lambda _Hello World!_

```javascript
const AWS = require("aws-sdk");
const s3 = new AWS.S3();

exports.handler = async (event) => s3.listBuckets().promise();
```

### AWS Lambda execution

```javascript
const AWS = require("aws-sdk"); // Dependencies included in runtime
const s3 = new AWS.S3(); // Credentials provided by environment (based on role)

// event populated per request
exports.handler = async (event) => s3.listBuckets().promise();
// response is returned to invoker by runtime
```

### Supported runtimes

#### Built-in

Node.js, Python, Ruby, Java, Go, .NET Core

#### Custom runtimes

Anything that runs in Amazon Linux 2.

:::notes

- https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
- https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html
- Amazon Linux 2: https://aws.amazon.com/amazon-linux-2/

:::

### When should I use Lambda?

Lambda is best suited for shorter, event-driven workloads, since Lambda
functions run for up to 15 minutes per invocation.

### Other limits

- RAM: max 10 GB
- payload (event): max 6 MB
- source code size: max 25 MB / 10 GB container image
- open files: 1,024
- `/tmp` size: max 512 MB

### Scaling

- first invokation (event) creates a function instance
- stays active after response and waits to process additional events
- more instances are created if multiple events need processing at the same time
- instances are discared if number of events decreases

![Autoscaling with Provisioned Concurrency](./features-scaling-provisioned-auto.png){width=50%}

:::notes

https://docs.aws.amazon.com/lambda/latest/dg/invocation-scaling.html

The first time you invoke your function, AWS Lambda creates an instance of the
function and runs its handler method to process the event. When the function
returns a response, it stays active and waits to process additional events. If
you invoke the function again while the first event is being processed, Lambda
initializes another instance, and the function processes the two events
concurrently. As more events come in, Lambda routes them to available instances
and creates new instances as needed. When the number of requests decreases,
Lambda stops unused instances to free up scaling capacity for other functions.

:::

### Lambda execution environments

Lambda provides **function version level isolation**:

- reserved for a specific function version
  - no reuse across function versions, functions, or AWS accounts
- only one concurrent invocation at a time

:::notes

This means a single function which may have two different versions would result
in at least two unique execution environments.

Each execution environment may only be used for one concurrent invocation at a
time, and they may be reused across multiple invocations of the same function
version for performance reasons. Depending on a number of factors (for example,
rate of invocation, function configuration, and so on), one or more execution
environments may exist for a given function version. With this approach, Lambda
is able to provide function version level isolation for its customers.

Execution environments are continuously monitored and managed by Lambda, and
they may be created or destroyed for any number of reasons including, but not
limited to:

- A new invoke arrives and no suitable execution environment exists
- An internal runtime or Worker software deployment occurs
- A new provisioned concurrency configuration is published
- The lease time on the execution environment, or the Worker, is approaching or
  has exceeded max lifetime
- Other internal workload rebalancing processes

Source:
https://docs.aws.amazon.com/whitepapers/latest/security-overview-aws-lambda/lambda-executions.html

:::

### Execution environment

![A diagram showing the isolation model for AWS Lambda Workers.](./lambda-execution-environment.png){width=70%}

Execution environments are isolated from one another using several
container-like technologies. Amazon open-sourced their virtualization
technology, called [Firecracker](https://firecracker-microvm.github.io/).

:::notes

Lambda will create its execution environments on a fleet of Amazon EC2 instances
called AWS Lambda Workers. Workers are bare metalEC2 Nitro instances which are
launched and managed by Lambda in a separate isolated AWS account which is not
visible to customers. Workers have one or more hardware-virtualized Micro
Virtual Machines (MVM) created by Firecracker. Firecracker is an open-source
Virtual Machine Monitor (VMM) that uses Linux’s Kernel-based Virtual Machine
(KVM) to create and manage MVMs. It is purpose-built for creating and managing
secure, multi-tenant container and function-based services that provide
serverless operational models.

As a part of the shared responsibility model, Lambda is responsible for
maintaining the security configuration, controls, and patching level of the
Workers. The Lambda team uses Amazon Inspector to discover known potential
security issues, as well as other custom security issue notification mechanisms
and pre-disclosure lists, so that customers don’t need to manage the underlying
security posture of their execution environment.

Workers have a maximum lease lifetime of 14 hours. When a Worker approaches
maximum lease time, no further invocations are routed to it, MVMs are gracefully
terminated, and the underlying Worker instance is terminated. Lambda
continuously monitors and alarms on lifecycle activities of its fleet’s
lifetime.

All data plane communications to workers are encrypted using Advanced Encryption
Standard with Galois/Counter Mode (AES-GCM). Other than through data plane
operations, customers cannot directly interact with a worker as it hosted in a
network isolated Amazon VPC managed by Lambda in Lambda’s service accounts.

When a Worker needs to create a new execution environment, it is given
time-limited authorization to access customer function artifacts. These
artifacts are specifically optimized for Lambda’s execution environment and
workers. Function code which is uploaded using the ZIP format is optimized once,
and then is stored in an encrypted format using an AWS-managed key and AES-GCM.

Functions uploaded to Lambda using the container image format are also
optimized. The container image is first downloaded from its original source,
optimized into distinct chunks, and then stored as encrypted chunks using an
authenticated convergent encryption method which uses a combination of AES-CTR,
AES-GCM, and a SHA-256 MAC. The convergent encryption method allows Lambda to
securely deduplicate encrypted chunks. All keys required to decrypt customer
data is protected using customer-managed AWS KMS Customer Master Key (CMK). CMK
usage by the Lambda service is available to customers in AWS CloudTrail logs for
tracking and auditing.

Source:
https://docs.aws.amazon.com/whitepapers/latest/security-overview-aws-lambda/lambda-executions.html

See also:
https://docs.aws.amazon.com/whitepapers/latest/security-overview-aws-lambda/lambda-isolation-technologies.html

:::

### Execution environment lifecycle

![The execution environment lifecycle](./execution-environment-lifecycle.png)

1. download the code for the function from S3 or ECR
2. create environment with the memory, runtime, and configuration specified
3. run any initialization code outside of the event handler
4. run the handler code.

:::notes

When the Lambda service receives a request to run a function via the Lambda API,
the service first prepares an execution environment. During this step, the
service downloads the code for the function, which is stored in an internal S3
bucket (or in Amazon ECR if the function uses container packaging). It then
creates an environment with the memory, runtime, and configuration specified.
Once complete, Lambda runs any initialization code outside of the event handler
before finally running the handler code.

In this diagram, the first two steps of setting up the environment and the code
are frequently referred to as a “cold start”. You are not charged for the time
it takes for Lambda to prepare the function but it does add latency to the
overall invocation duration.

After the execution completes, the execution environment is frozen. To improve
resource management and performance, the Lambda service retains the execution
environment for a non-deterministic period of time. During this time, if another
request arrives for the same function, the service may reuse the environment.
This second request typically finishes more quickly, since the execution
environment already exists and it’s not necessary to download the code and run
the initialization code. This is called a “warm start”.

Source:
https://docs.aws.amazon.com/lambda/latest/operatorguide/execution-environments.html

:::

### Hitting the cold start zone

![Lambda cold starts](./cold-starts.png)

Lambda service retains the execution environment for a non-deterministic period
of time.

:::notes

The Lambda service retains the execution environment instead of destroying it
immediately after execution. There are also operational factors in the Lambda
services that influence the retention time.

While execution environment reuse is useful, you should not depend on this for
performance optimization. Lambda is a high availability service that manages
execution across multiple Availability Zones in an AWS Region. Depending upon
aggregate customer traffic, the service may load balance a function at any time.
As a result, it’s possible for a function to be invoked twice in a short period
of time, and both executions experience a cold-start due to this load
rebalancing activity.

Additionally, in the event that a Lambda function scales up due to traffic, each
additional concurrent invocation of the function requires a new execution
environment. This means that each concurrent execution experiences a cold-start,
even as existing concurrent functions may already be warm.

Finally, anytime you update the code in a Lambda function or change the
functional configuration, the next invocation results in a cold start. Any
existing environments running a previous version of the “Latest” alias are
reaped to ensure that only the new version of the code is used.

:::

### Cold start scenarios

### 6 simultaneous requests

![6 simultaneous requests](./simultaneous-requests.png)

:::notes

If API Gateway invokes Lambda six times simultaneously, this causes Lambda to
create six execution environments. The total duration of each invocation
includes a cold start:

:::

### 6 asynchronous inviations with reserved concurrency 1

![6 asynchronous inviations with reserved concurrency 1](./asynchronous-inviations.png)

:::notes

However, if API Gateway invokes Lambda 6 times sequentially with a delay between
each invocation, the existing execution environments are reused if the previous
invocation is complete. In this case, only the first two invocations experience
a cold start, while invocations 3 through 6 use warm environments.

:::

### 6 requests with staggered arrival

![S3 bucket events](./s3-events.png)

![6 requests with staggered arrival](./staggered-arrival.png)

:::notes

For asynchronous invocations, an internal queue exists between the caller and
the Lambda service. Lambda processes messages from this queue as quickly as
possible and scales up automatically as needed. In the event that the function
uses reserved concurrency, this acts as a maximum capacity, so the internal
queue retains the messages until the function can process them.

For example, an S3 bucket is configured to invoke a Lambda function when objects
are written to the bucket, if the reserved capacity of the Lambda function is
set to 1 and 6 objects are written to the bucket simultaneously, the events are
processed sequentially by a single execution environment. Pending events are
maintained in the internal queue.

:::

### Cold start times

[![Cold start times](./cold-start-times.png)](https://mikhail.io/serverless/coldstarts/aws/languages/)

- typically <1% of invocations in production deployments

:::notes

According to an analysis of production Lambda workloads, cold starts typically
occur in under 1% of invocations. The duration of a cold start varies from under
100 ms to over 1 second. Since the Lambda service optimizes internally based
upon invocation patterns for functions, cold starts are typically more common in
development and test functions than production workloads. This is because
development and test functions are usually invoked less frequently. Overall, the
Lambda service optimizes the execution of functions across all customers to
reduce the number of cold starts.

Source:
https://aws.amazon.com/blogs/compute/operating-lambda-performance-optimization-part-1/

Chart source: https://mikhail.io/serverless/coldstarts/aws/languages/

:::

### Cold start mitigation

- reserved concurrency (keep _n_ instances alive all the time)
- reduce cold start time:
  - reduce deployment artifact size
  - chose _leaner_ execution environment
  - give more resources to Lambda (RAM)
  - reduce start up time (e.g. DB connections)
  - reduce processing run time

## Why I like _serverless_

_Serverless computing allows me to focus on implementing the solution, and not
spend time on maintaining the infrastructure needed to execute it._

### or more practical

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

### Horizontal Scalablity

- Serverless implementations depend on _stateless_, _event-driven_
  implementations.
- This allows to process as many requests as needed, in _parallel_.
- However, you have to deal with eventual consistency.

### Updating individual components

Instead of restarting the instance,  
I can update _an individual function_.

:::notes

Serverless not only enables horizontal scalability, but allows to update each
component of the solution individually: the code for a lambda function can be
replaced without affecting other functions. This means no more waiting minutes
for a monolithic container to come up again after a fix has been deployed.

:::

### Downsides of _serverless_

### Testability

- Testing cloud-native solutions really is a challenge.

:::notes

You can see my talk about testing cloud-native solutions here:
https://coderbyheart.com/it-does-not-run-on-my-machine/

:::

### Infrastructure is part of the solution

- More ceremony involved, defining infrastructure as code is now your job.

### Serverless is usually closed source

- Impossible to run it locally.

### Mindset shift

- Huge mindset shift from the classical application server model (LAMP, Tomcat,
  Rails), to a serverless, stateless, eventual consistent application
  development model.

## IoT <3 _serverless_

### No **world**

- Many, many devices, that don't share global state.

### 18+ billion IoT devices this year

- Needs to scale to billions of devices, connections, message per day.

:::notes

https://www.ericsson.com/en/about-us/company-facts/ericsson-worldwide/india/authored-articles/ushering-in-a-better-connected-future

:::

### Data for thousands of use cases

- Many different operations with different business needs (processing) on small
  datasets, suits serverless microservice model very well.

### Architecture Example: store and retrieve temperature data

![Historical Data](./historical-data.jpg)

[miro.com/app/board/o9J_llBJjJM=](https://miro.com/app/board/o9J_llBJjJM=/)

### AWS implementation

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

We are hiring summer students and graduates!  
[nordicsemi.com/jobs](https://nordicsemi.com/jobs)  
<small>Trondheim &middot; Oslo</small>
