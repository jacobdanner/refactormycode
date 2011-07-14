Long time ago, I met [RefactorMyCode.com](http://refactormycode.com) by accident while searching some programming tips, then I registered on the site as its fan. I like its way sharing programming skills with other people. 

Three months ago, I started my career at [Intridea](http://intridea.com), there I was allowed to select one SparkTime Project to work on in my spare time. Yeah, that's great, here in intridea we are encouraged to work on every possible interesting project as a SparkTime project. You know, surprisingly, I found **RefactorMyCode** was in the list, then I picked it up happily.

#### **About RefactorMyCode** ####

One of my colleagues, [Jon](http://intridea.com/about/people/jonbishop), mentioned RefactorMyCode project status two months ago in a [blog post](http://intridea.com/2011/4/18/-refactormycode-lives-on-open-source-coming-soon). It's originally running on **Rails 2.0.2**, that's really out of date according to Rails' fast upgrading speed. Thus I decided to upgrade it to **Rails 3.0** before open-sourcing it.

#### **What's happening to RefactorMyCode in last few months?** ####

![RefactorMyCode.com](https://img.skitch.com/20110628-x8pwpuuba4dmkg4kr4fdf9xua5.jpg)

Obviously, upgrading Rails 2.0.2 to Rails 3.0 is a pain as it has a two-years updating gap between this two versions. The main troubles are to fix **routes** and **ajax** related issues. Here the [rails_upgrade](https://github.com/jm/rails_upgrade) plugin really helps that out. 

In our case, some of its ajax requests were canceled and refactored as direct requests, that'd be more flexible. We removed the old [will_paginate](https://github.com/mislav/will_paginate) and used [kaminari](https://github.com/amatsuda/kaminari) as its new pagination solution. Similar updates include upgrading to [acts-as-taggable-on](https://github.com/mbleigh/acts-as-taggable-on) and syntax highligh functions with [coderay](http://coderay.rubychan.de/).

We also refactored the existing authentication solution with [omniauth](https://github.com/intridea/omniauth), so the new rails3 version will allow you to login RefactorMyCode with more third party services, such as [github](http://github.com), [twitter](http://twitter.com) and [linkedin](http://linkedin.com) etc.

#### **Ready for open source?** ####

Answer is, YES! 

However, I am still adding rSpec test code for the rails3 version project, and also I am researching for a better syntax highlighting solution in pure ruby way, it seems [Albino](https://github.com/github/albino) fits the needs well. So well, you are welcomed to contribute in these aspects of project.


