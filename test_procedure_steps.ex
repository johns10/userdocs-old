WebDriver.Driver.new()

login_procedure = [
  %{
    :type     => :navigate,
    :url      => "https://staging.app.funnelcloud.io/#/setup"
  },
  %{
    :type     => :wait,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[1]|
  },
  %{
    :type     => :click,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next')]|
  },
  %{
    :type     => :wait,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//div[@class='modal-container']/div/div[@class='content']/div/div[1]/div[3]|
  },
  %{
    :type     => :click,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//div[@class='modal-container']/div/div[@class='content']/div/div[1]/div[3]|
  },
  %{
    :type     => :wait,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next Page')]|
  },
  %{
    :type     => :click,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next Page')]|
  },
  %{
    :type     => :wait,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Save')]|
  },
  %{
    :type     => :click,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Save')]|
  },
  %{
    :type     => :navigate,
    :url      => "https://staging.app.funnelcloud.io/#/login"
  },
  %{
    :type     => :wait,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Username']|
  },
  %{
    :type     => :fill_field,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Username']|,
    :text => "admin@funnelcloud.io"
  },
  %{
    :type     => :fill_field,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Password']|,
    :text => "FirstTimer"
  },
  %{
    :type     => :click,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]//form//button|
  },
]

ataglance = %{
  :url        => "https://staging.app.funnelcloud.io/#/plant/All/overview/at-a-glance"
  :procedure  => %{
    :type     => :wait,
    :strategy => :xpath,
    :selector => ~s|/html/body/div[@class='ember-view']/div[9]/div//table/tbody|
  }


}

WebDriver.Procedure.execute_procedure(login_procedure)
