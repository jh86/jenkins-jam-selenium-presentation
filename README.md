class: center, middle

# Selenium testing with Jenkins for great justice!
## Tips and tricks to make the most of your automated testing

Created by Jon Hermansen  
[github.com/jonhermansen](https://github.com/jonhermansen)
[twitter.com/jonhermansen](https://twitter.com/jonhermansen)

---

# About me

```perl
#!/usr/bin/perl

my $workplace = 'Verizon Digital Media Services';
sub job_function { return 'Software Engineer in Test'; }
my @languages = qw/js perl python/;
```

* [We're hiring, check us out!](https://www.verizondigitalmedia.com/careers/)
* I recently became Jenkins certified
  * Jenkins Engineer
  * CloudBees Jenkins Platform Jenkins Engineer

---

# Agenda

1. Test philosophy
2. Selenium intro
3. Jenkins job setup tips
4. Sharing Jenkins with colleagues
5. Maintaining your tests in the long term

---

class: center, middle

# Test philosophy

---

# What do tests do for us?

* Tells developers if their changes broke existing features
* Tells testers "how ready" the build is and whether it is worth manual test effort
* Tells product management about the health of their product as it's changing
* This feedback can allow the business to adjust when things aren't working as expected

---

# What should I test?

* Do you take orders/payments online?
    * Follow the money
    * Automate placing test orders in a staging environment, then see if you can run this infrequently in production
* What features provide the most value to your customers?
    * Use analytics to determine what actions users take the most
* Look at browser usage to determine which browser should be mainly used for test development

---

# Tests = Monitoring?

* test, noun - a procedure intended to establish the quality, performance, or reliability of something, especially before it is taken into widespread use.
* mon·i·tor, noun - an instrument or device used for observing, checking, or keeping a continuous record of a process or quantity.
* Monitoring is just running tests after deployments to production (carefully)?

---

class: center, middle

# Selenium intro

---

# What is Selenium?

> a suite of tools to automate web browsers across many platforms

* Automate interactions with your web application
  * Try to model what an actual human would do
* Includes a backend server (a Java .jar) and client libraries for many languages
* A huge ecosystem of testing tools have been built around it

---

# It's easy to get started

* You don't even need to know how to code!
* You can record your actions and generate test code using these browser plugins:
    * [Selenium IDE](https://addons.mozilla.org/en-US/firefox/addon/selenium-ide/)
    * [Selenium Builder](http://seleniumbuilder.github.io/se-builder/)
* API testing too? No problem!
    * [Postman](https://www.getpostman.com/)
    * [newman](https://github.com/postmanlabs/newman)
* You could even integrate your API tests with your UI tests!
    * POST via API, check via UI
    * Submit form via UI, check via API

---

# Should I use Selenium RC (v1) or WebDriver (v2, v3)?

* Selenium RC is dead, effectively
* WebDriver can do pretty much anything RC does
* WebDriver is becoming a [W3C standard](https://www.w3.org/TR/webdriver/)
* If needed, you can mix Selenium RC commands with WebDriver commands in your test
* Don't hold your breath for Selenium 3?

---

# Choosing a Selenium client driver

It's complicated... which client do you use?

* [Python official client](https://pypi.python.org/pypi/selenium)
* [JavaScript official client](https://www.npmjs.com/package/selenium-webdriver)
* [JavaScript unofficial client](http://webdriver.io/)
* seleniumhq.org has a list of clients on their [download page](http://docs.seleniumhq.org/download/) 

---

# Selenium Grid intro

Grid allows you to:
* scale by distributing tests on several machines ( parallel execution )
* manage multiple environments from a central point, making it easy to run the tests against a vast combination of browsers / OS.
* minimize the maintenance time for the grid by allowing you to implement custom hooks to leverage virtual infrastructure for instance.

---

# Selenium Grid + Jenkins

1. Install Jenkins 
2. Install [Selenium Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Selenium+Plugin)
3. Profit!!!
4. Just kidding
5. Point your tests at your Jenkins master port 4444, sending capabilities to allow grid to pick a capable server.

---

# Testing with different browsers

* Firefox is very lenient, does not throw an exception if element is off screen
* Chrome will warn about missing/hidden elements, forcing you to code around asynchronous HTTP requests
    * You may need to set Selenium's resolution explicitly
    * **Lazy case**: look for one of the last elements that is loaded on the screen before you start your test
    * **Best case**: add a hook (global variable?) that your production application can use to signal it is ready for testing
    * **Worst case**: hook XmlHttpRequest until you see the required data, wait until it is loaded, then run test code

---

class: center, middle

# Jenkins job setup tips

---

# How's your test reporting?

* If you're already using a test runner with pluggable reporters, you can probably have it write a JUnit report.
* You can easily add JUnit or TAP test reporting to your existing test suite.
* Worst case, if your test code calls pass() or fail() functions you can hook them.
* TAP is also a thing!

---

# JUnit reporters/test runners:

* NodeJS - [mocha](https://mochajs.org/)
* Python - [pytest](http://pytest.org/latest/)
* Bash? - [shell2junit](https://code.google.com/archive/p/shell2junit/)

---

# Look for a test runner that:

* Has built in JUnit reporting (no plugins)
    * nice to have: skipped test reporting
* Is easy to integrate your tests with
* Is easy to install on all applicable platforms
* Nice to have: can capture stdout/stderr and timing information

---

# Dealing with other types of reporters

* [TAP](https://testanything.org/)
  * [tap2junit](http://search.cpan.org/~gtermars/TAP-Formatter-JUnit-0.08/bin/tap2junit)
* [NUnit](http://www.nunit.org/)
    * [NUnit Plugin](https://wiki.jenkins-ci.org/display/JENKINS/NUnit+Plugin)
      * Has drawbacks, I prefer to use the stock JUnit reporter plugin so I convert NUnit to JUnit at the end of shell steps
    * [nunit-to-junit](https://github.com/jenkinsci/nunit-plugin/blob/master/src/main/resources/hudson/plugins/nunit/nunit-to-junit.xsl)
      * xsltproc to the rescue!
* [CUnit](http://cunit.sourceforge.net/)
    * [cunit-to-junit](http://git.cyrusimap.org/cyrus-imapd/plain/cunit/cunit-to-junit.pl)

---

# Flaky tests?

* [Test Stability Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Test+stability+plugin)
* [Test Results Analyzer Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Test+Results+Analyzer+Plugin)
* [Quarantine Plugin](https://github.com/samsta/quarantine)

---

# Slow tests?

* Look for unnecessary waiting
* Look for unnecessary Selenium session teardowns
* Find a way to determine when the application is fully loaded
* Does your application's static content get cached?
* Does your application serve compressed content?
* [Google's performance recommendations](https://developers.google.com/speed/)
* [Mozilla's performance recommendations](https://developer.mozilla.org/en-US/Apps/Fundamentals/Performance/Performance_fundamentals)

---

# Destructive tests

* Skip when running on production
* Always try to cleanup on CTRL+C / signals
* Don't forget to close your Selenium session!

---

# Sauce Labs

* Run your tests as frequently and as quickly as possible
    * Provide quicker feedback to developers when they've broken something
* Sauce Labs and similar services will enable you to do this
* **Not** managing your own Selenium infrastructure will pay off in the short term
* [Selenium has a list of other similar services](http://www.seleniumhq.org/ecosystem/)

---

# Where is my test running?

* On a developer's workstation, assume no environment variables are set and pick a default browser
* Within Jenkins, no or some environment variables may be set
    * JENKINS_HOME can be used to easily determine whether we're running under Jenkins
    * Sauce Labs plugin sets certain environment variables that can be used by your test dynamically
      * SELENIUM_HOST, SELENIUM_PORT, SELENIUM_PLATFORM, SELENIUM_BROWSER, SELENIUM_VERSION
      * [More info here](https://wiki.saucelabs.com/display/DOCS/Environment+Variables+Used+by+the+Jenkins+Plugin)

---

class: center, middle

# Sharing Jenkins with colleagues

---

# Managing credentials

* [Credentials Binding Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Credentials+Binding+Plugin)
* Add your credentials to Jenkins as an admin
* Allow your credentials' use by colleagues
* Git hack for HTTPS only: create a ~/.netrc file
    * You can use a revokable API key as a password with GitHub

---

# Make your Jenkins instance secure

* Secure transport communications with HTTPS, Lets Encrypt?
* Disable "Anyone can do anything" in "Configure Global Security"
* [Jenkins Wiki - Securing Jenkins](https://wiki.jenkins-ci.org/display/JENKINS/Securing+Jenkins)
* [Jenkins Wiki - Standard Security Setup](https://wiki.jenkins-ci.org/display/JENKINS/Standard+Security+Setup)
* Jenkins credentials binding
* [Saucelabs Wiki - Best Practice: Use Environment Variables for Authentication Credentials](https://wiki.saucelabs.com/display/DOCS/Best+Practice%3A+Use+Environment+Variables+for+Authentication+Credentials)

---

# Authentication and Authorization

* [Active Directory Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Active+Directory+plugin)
    * This plugin only requires the hostname of your AD server
* [GitHub Authentication Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Github+OAuth+Plugin)
    * Easy to set up as a non-admin user
    * Works with enterprise GitHub installations
* [LDAP Plugin](https://wiki.jenkins-ci.org/display/JENKINS/LDAP+Plugin)
    * More complex setup which is dependent on your LDAP schema
* [Matrix-based security](https://wiki.jenkins-ci.org/display/JENKINS/Matrix-based+security)
    * Give permissions based on groups
* [Matrix Authorization Strategy Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Matrix+Authorization+Strategy+Plugin)
    * Give permissions based on groups, but on a per-project basis

---

# Make your Jenkins instance accessible

* Use dynamic DNS and/or a hosted DNS service (CloudFlare?)
    * Makes your instance available by a convenient name, usable by others
    * You can create an external DNS record that refers to your internal network
      * CNAME work.jenkins-user.net -> jenkins-users-desktop.internal-network-name.biz
---

# Show your progress frequently
> Check In Early, Check In Often
> - Jeff Atwood

* CI should be consumable by all stakeholders (QA, devs, product)
* Half working jobs are basically useless to anyone else but you
* Clean up after yourself!
    * Hide your experimental jobs in a folder:
      * [CloudBees Folders Plugin](https://github.com/jenkinsci/cloudbees-folder-plugin) -- Open Source!
    * Create a custom default view
      * [Jenkins Wiki - Editing or Replacing the All View](https://wiki.jenkins-ci.org/display/JENKINS/Editing+or+Replacing+the+All+View)
* Create an "information radiator" using Jenkins
    * Set up a second monitor to display it at all times

---

# Information radiator

* [Alistair Cockburn on Information radiators](http://alistair.cockburn.us/Information+radiator)
> An Information radiator is a display posted in a place where people can see it as they work or walk by. It shows readers information they care about without having to ask anyone a question. This means more communication with fewer interruptions.
* [Build Monitor Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Build+Monitor+Plugin)
* [Dashboard View Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Dashboard+View)
* [Jenkins Blog - A beautiful Jenkins dashboard](https://jenkins.io/blog/2016/01/10/beautiful-jenkins-dashboard/)

---

class: center, middle

# Maintaining your tests in the long term

---

# Testing your tests (Yo dawg)

* Add a git pre-commit hook to prevent code from being committed that won't compile
    * Check this at build time too
* You can unit test your tests!
* [Validated Merge Plugin](https://www.cloudbees.com/products/cloudbees-jenkins-platform/team-edition/features/validated-merge-plugin) (Jenkins Enterprise only)
* Look out for ugly code...

---

# Enforcing code standards in your test repository

* git pre-commit hook again
* alternatively, a git post-commit hook can clean your code up after you
    * [Checkstyle Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Checkstyle+Plugin)
    * [Warnings Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Warnings+Plugin)
    * [Violations Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Violations)
    * [SonarQube Plugin](https://wiki.jenkins-ci.org/display/JENKINS/SonarQube+plugin)

---

class: center, middle

# Questions?

---

class: center, middle

# Thanks for coming!
