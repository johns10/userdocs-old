defmodule ProcedureTest do
  use ExUnit.Case
  doctest WebDriver
  use Hound.Helpers

  alias WebDriver.Procedure
  alias WebDriver.Driver

  hound_session(driver: Driver.setup())

  test "executes a navigate step" do
    Procedure.execute_procedure_step({
      :navigate,
      %{ url: "https://www.google.com/" }
    })
    assert(current_url() == "https://www.google.com/")
  end

  test "executes waits until available" do
    Procedure.execute_procedure_step({
      :navigate,
      %{ url: "http://webdriveruniversity.com/Ajax-Loader/index.html" }
    })
    Procedure.execute_procedure_step({
      :wait,
      %{ strategy: :xpath, selector: ~s|//span[@id='button1']/p[.='CLICK ME!']| }
    })
    text = find_element(:xpath, ~s|//span[@id='button1']/p[.='CLICK ME!']|)
    |> visible_text()
    assert(text == "CLICK ME!")
  end

  test "executes a click step" do
    Procedure.execute_procedure_step({
      :navigate,
      %{ url: "http://webdriveruniversity.com/Click-Buttons/index.html" }
    })
    Procedure.execute_procedure_step({
      :click, %{
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='container']/div[2]/div/div[@class='row']/div[1]/div[@class='thumbnail']/div[@class='caption']/span[@class='btn btn-default btn-lg dropdown-toggle']/p[.='CLICK ME!']|
      }
    })
    Procedure.execute_procedure_step({
      :wait,
      %{ strategy: :xpath, selector: ~s|/html//div[@id='myModalClick']//div[@class='modal-footer']/button[@type='button']| }
    })

    text = find_element(:xpath, ~s|/html//div[@id='myModalClick']//div[@class='modal-footer']/button[@type='button']|)
    |> visible_text()
    assert(text == "Close")
  end

  test "executes a fill field step" do
    selector = ~s|/html//form[@id='tsf']//div[@class='a4bIc']/input[@role='combobox']|
    test = "test"
    Procedure.execute_procedure_step({
      :navigate,
      %{ url: "https://www.google.com" }
    })
    Procedure.execute_procedure_step({
        :fill_field, %{
          strategy: :xpath,
          selector: selector,
          text: test
        }
      })
      find_element(:xpath, ~s|/html//form[@id='tsf']//div[@class='a4bIc']/input[@role='combobox']|)
      |> visible_text()
      #I don't know what to assert.  I don't get text back.
  end

  test "executes an entire procedure" do
    procedure = [
      %{
        :type     => :navigate,
        :url      => "http://webdriveruniversity.com/Contact-Us/contactus.html"
      },
      %{
        :type     => :wait,
        :strategy => :xpath,
        :selector => ~s|//div[@id='form_buttons']/input[@value='RESET']|
      },
      %{
        :type     => :fill_field,
        :strategy => :xpath,
        :selector => ~s|//form[@id='contact_form']/input[@name='first_name']|,
        :text => "foo"
      },
      %{
        :type     => :fill_field,
        :strategy => :xpath,
        :selector => ~s|//form[@id='contact_form']/input[@name='last_name']|,
        :text => "bar"
      },
      %{
        :type     => :fill_field,
        :strategy => :xpath,
        :selector => ~s|//form[@id='contact_form']/input[@name='email']|,
        :text => "foo@bar.com"
      },
      %{
        :type     => :fill_field,
        :strategy => :xpath,
        :selector => ~s|//form[@id='contact_form']/input[@name='email']|,
        :text => "foo@bar.com"
      },
      %{
        :type     => :fill_field,
        :strategy => :xpath,
        :selector => ~s|//form[@id='contact_form']/textarea[@name='message']|,
        :text => "Test"
      },
      %{
        :type     => :click,
        :strategy => :xpath,
        :selector => ~s|//div[@id='form_buttons']/input[@value='SUBMIT']|
      },
      %{
        :type     => :wait,
        :strategy => :xpath,
        :selector => ~s|//div[@id='contact_reply']/h1[.='Thank You for your Message!']|
      },
    ]
    text = Procedure.execute_procedure(procedure)
    find_element(:xpath, ~s|//div[@id='contact_reply']/h1[.='Thank You for your Message!']|)
    |> visible_text()
    assert(text == "Thank You for your Message!")
  end

  test "executes an javascript step" do
    procedure = [
      navigate: %{url: "https://varvy.com/pagespeed/wicked-fast.html"},
      wait: %{
        selector: "//div[@id='menu']/ul//a[@href='/']",
        strategy: :xpath
      },
      javascript: %{
        color: 'red',
        label: "1",
        script_type: :badge,
        selector: ~s|//div[@id='menu']/ul//a[@href='/']|,
        size: 15,
        strategy: :xpath
      }
    ]
    text = Procedure.execute_procedure(procedure)
  end
end

