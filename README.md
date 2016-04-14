# Selenium testing with Jenkins for great justice!
## Tips and tricks to make the most of your automated testing

Created by [Jon Hermansen](https://github.com/jh86) / [@jonhermansen](https://twitter.com/jonhermansen)

---

# About me
		    
```perl
#!/usr/bin/perl

my $workplace = 'Verizon Digital Media';
sub job_function { return 'Software Engineer in Test'; }
my @languages = qw/js perl python/;
```

---

# Agenda

1. Test philosophy
2. Jenkins job setup
3. ...

[Google][]

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

# It's easy to get started!
## You don't even need to know how to code!

* You can record your actions and generate test code using these browser plugins:
  * Selenium IDE: https://addons.mozilla.org/en-US/firefox/addon/selenium-ide/
  * selenium-builder: https://github.com/SeleniumBuilder/selenium-builder
  * 
* API testing? No problem!
  * https://www.getpostman.com/
  * newman: https://github.com/postmanlabs/newman

---

# Should I use Selenium RC or WebDriver?

* Selenium RC is dead, effectively
* WebDriver is the new way forward!
* WebDriver is becoming a W3C standard: https://www.w3.org/TR/webdriver/
* If needed, you can mix Selenium RC commands with WebDriver commands in your test

---

# How's your test reporting?

* If you're already using a test runner with pluggable reporters, you can probably have it write a JUnit report.
* You can easily add JUnit or TAP test reporting to your existing test suite.
* Worst case, if your test code calls pass() or fail() functions you can hook them.
* TAP is also a thing!

---

# Dealing with other types of reporters

* TAP - tap2junit: http://search.cpan.org/~gtermars/TAP-Formatter-JUnit-0.08/bin/tap2junit
* NUnit
  * nunit: https://github.com/jenkinsci/nunit-plugin
    * Has drawbacks, I prefer to use the stock JUnit reporter plugin so I convert NUnit to JUnit at the end of shell steps
  * nunit-to-junit: https://github.com/jenkinsci/nunit-plugin/blob/master/src/main/resources/hudson/plugins/nunit/nunit-to-junit.xsl
    * xsltproc to the rescue!
* CUnit
  * cunit-to-junit: http://git.cyrusimap.org/cyrus-imapd/plain/cunit/cunit-to-junit.pl


---

# Look for a test runner that:

* has built in JUnit reporting (no plugins)
  * nice to have: including skipped test reporting
* is easy to integrate your tests with
* is easy to install on all applicable platforms
* nice to have: can capture stdout/stderr and timing information from your test cases

---

# JUnit reporters/test runners:

* NodeJS - mocha: https://mochajs.org/
* Python - pytest: http://pytest.org/latest/
* Bash? - shell2junit: https://code.google.com/archive/p/shell2junit/

---

# Selenium basics

It's complicated... which client do you use?

* Python official client - selenium - https://pypi.python.org/pypi/selenium
* JS official client - selenium-webdriver - https://www.npmjs.com/package/selenium-webdriver
* JS unofficial client - webdriver.io - http://webdriver.io/
* seleniumhq.org has a list of clients on their download page: http://docs.seleniumhq.org/download/

---

# Selenium grid basics

1. Install Jenkins 
2. Install Selenium Plugin
3. Profit!!!

...

4. Point your tests at your Jenkins master port 4444, sending capabilities to allow grid to pick a capable server.

---

# Browser differences

* Firefox is lenient, does not throw an exception if element is off screen
* Chrome will warn about missing/hidden elements, forcing you to code around asynchronous HTTP requests
  * You may need to set Selenium's resolution explicitly
  * Lazy case: look for one of the last elements that is loaded on the screen before you start your test
  * Best case: add a hook (global variable?) that your production application can use to signal it is ready for testing
  * Worst case: hook XmlHttpRequest until you see the required URL, wait until it is loaded, then run test code

---

# Flaky tests?

* test-stability: https://github.com/jenkinsci/test-stability-plugin
* test-results-analyzer: https://github.com/jenkinsci/test-results-analyzer-plugin
* quarantine: https://github.com/samsta/quarantine

---

# Slow tests?

* Look for unnecessary waiting
* Look for unnecessary Selenium session teardowns
* Find a way to determine when the application is fully loaded
* Does your application's static content get cached?
* Does your application serve compressed content?
* Google's performance recommendations: https://developers.google.com/speed/
* Mozilla's performance recommendations: https://developer.mozilla.org/en-US/Apps/Fundamentals/Performance/Performance_fundamentals

---

# Sauce Labs

* Run your tests as frequently and as quickly as possible
  * Provide quicker feedback to developers when they've broken something
* Sauce Labs and similar services will enable you to do this.
* NOT managing your own Selenium infrastructure will pay off in the short term.
* See also: http://www.seleniumhq.org/ecosystem/

---

# Tests = Monitoring?

* test, noun - a procedure intended to establish the quality, performance, or reliability of something, especially before it is taken into widespread use.
* mon·i·tor, noun - an instrument or device used for observing, checking, or keeping a continuous record of a process or quantity.
* Monitoring is just running tests after deployments to production (carefully)?

---

# Destructive tests

* Skip when running on production
* Always try to cleanup on CTRL+C / signals
* Don't forget to close your Selenium session!

---

# Managing credentials

* credentials-binding: https://github.com/jenkinsci/credentials-binding-plugin
* Add your credentials to Jenkins as an admin
* Allow your credentials' use by colleagues
* Git hack for HTTPS only: create a ~/.netrc file
  * You can use a revokable API key as a password with GitHub

---

# Make your Jenkins instance secure

* Secure transport communications with HTTPS, Lets Encrypt?
* Disable "Anyone can do anything" in "Configure Global Security"
* 
* Wiki - Securing Jenkins: https://wiki.jenkins-ci.org/display/JENKINS/Securing+Jenkins
* Wiki - Standard Security Setup: https://wiki.jenkins-ci.org/display/JENKINS/Standard+Security+Setup
* Jenkins credentials binding
* Saucelabs wiki: https://wiki.saucelabs.com/display/DOCS/Best+Practice%3A+Use+Environment+Variables+for+Authentication+Credentials

---

# Make your Jenkins instance accessible

* Use dynamic DNS and/or a hosted DNS service
  * Makes your instance available by a convenient name, usable by others
  * You can create an external DNS record that refers to your internal network
  * If you can get a static IP, this will make your machine available to anyone on your LAN

---

# Show your progress frequently
## "Check In Early, Check In Often" - Jeff Atwood

* CI should be consumable by all stakeholders
* Jobs that are created but broken are basically useless to anyone else but you
* Clean up after yourself!
  * You can hide your experimental jobs in a folder:
--- cloudbees-folder (open source!): https://github.com/jenkinsci/cloudbees-folder-plugin
* Create an "information radiator" using Jenkins
  * Set up a second monitor to display it at all times

---

# Information radiator

# Martin Fowler on communal dashboards: http://martinfowler.com/bliki/CommunalDashboard.html
* build-monitor-plugin: https://github.com/jan-molak/jenkins-build-monitor-plugin
* JAH TODO: more stuff here?
* dashboard-view: https://github.com/jenkinsci/dashboard-view-plugin
* Jenkins blog: https://jenkins.io/blog/2016/01/10/beautiful-jenkins-dashboard/

---

# Authentication and Authorization

* active-directory: https://github.com/jenkinsci/active-directory-plugin
  * This plugin only requires the hostname of your AD server
* github-oauth: https://github.com/jenkinsci/github-oauth-plugin
  * Easy to set up as a non-admin user
  * Works with enterprise GitHub installations
* ldap: https://github.com/jenkinsci/ldap-plugin
  * More complex setup, dependent on your LDAP schema
* Matrix-based security: https://wiki.jenkins-ci.org/display/JENKINS/Matrix-based+security

---

# Where is my test running?

* On a developer's workstation, assume no environment variables are set, pick a default browser
* Within Jenkins, no or some environment variables may be set
  * JENKINS_HOME can be used to easily determine whether we're running under Jenkins
  * Sauce Labs plugin sets certain environment variables that can be used by your test dynamically
  * Wiki: https://wiki.saucelabs.com/display/DOCS/Environment+Variables+Used+by+the+Jenkins+Plugin

---

# Testing your tests (Yo dawg)

* Add a git pre-commit hook to prevent code from being committed that won't compile
  * Check this at build time too
* You can unit test your tests!
* git-validated-merge (enterprise): https://www.cloudbees.com/products/cloudbees-jenkins-platform/team-edition/features/validated-merge-plugin
* Look out for gross code...

---

# Enforcing code standards in your test repository

* git pre-commit hook again
* alternatively, a git post-commit hook can clean your code up after you
  * checkstyle: https://github.com/jenkinsci/checkstyle-plugin
  * warnings: https://github.com/jenkinsci/warnings-plugin
  * violations: https://github.com/jenkinsci/violations-plugin
  * sonarqube (JAH TODO: no github link?): https://wiki.jenkins-ci.org/display/JENKINS/SonarQube+plugin

---

# The end.

  [google]: http://google.com/        "Google"
  [yahoo]:  http://search.yahoo.com/  "Yahoo Search"
  [msn]:    http://search.msn.com/    "MSN Search"
