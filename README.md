# StatGenRest
This project is a REST API that generates language statistics for organizations using the GitHub API v3.


## Requirements
* Unix shell
* Ruby 2.5.0
* Ruby on Rails 5.1.4
* Bundler 1.16.1 
* cURL 7.58.0
* GitHub account with a valid token (see https://github.com/settings/tokens)


## Steps to get the REST API up and running
```
$ cd to/project/dir
$ bundle install                                # install dependencies
$ bin/rails db:migrate RAILS_ENV=development    # migrate db
$ rails s                                       # start the server
```


## Tests
```
$ cd to/project/dir
$ bundle exec rspec spec/controllers/api/languages_controller_spec.rb   # run all tests for this controller
```


## Examples (REST API must be running)
```
$ export ORGANIZATION='replace_with_organization_name'
$ export GITHUB_TOKEN='replace_with_token'
$ curl -H "Authorization: token $GITHUB_TOKEN" http://127.0.0.1:3000/languages\?format\=json\&organization\=$ORGANIZATION
{
  "Ruby": "20.56%",
  "JavaScript": "16.38%",
  "CoffeeScript": "16.21%",
  "HTML": "16.08%",
  "Java": "15.36%",
  "CSS": "4.75%",
  "PHP": "4.62%",
  "Go": "2.26%",
  "Elixir": "2.11%",
  "Clojure": "1.06%",
  "C": "0.43%",
  "Makefile": "0.1%",
  "Shell": "0.01%"
}
```

## Save data to json files for analyzing (REST API must be running)
```
$ cd to/project/dir/command_line_tool/
$ export ORGANIZATION='replace_with_organization_name'
$ export GITHUB_TOKEN='replace_with_token'
$ ./get-stats.sh $ORGANIZATION $GITHUB_TOKEN
$ cat $ORGANIZATION-stats.json
{
  "Ruby": "39.19%",
  "TypeScript": "19.27%",
  "JavaScript": "17.43%",
  "C++": "13.24%",
  "Python": "5.12%",
  "Java": "2.11%",
  "C": "1.28%",
  "HTML": "1.05%",
  "CSS": "0.94%",
  "Shell": "0.09%",
  "Ragel": "0.04%",
  "Makefile": "0.04%",
  "Protocol Buffer": "0.04%",
  "Dart": "0.03%",
  "Lua": "0.02%",
  "Go": "0.01%",
  "PHP": "0.0%",
  "Mako": "0.0%",
  "LiveScript": "0.0%",
  "M4": "0.0%",
  "Batchfile": "0.0%",
  "XSLT": "0.0%"
}
```