defmodule SubscriptionTest do
  use ExUnit.Case
  doctest Subscription

  test "basic subscription test" do
    Subscription.Handler.handle(
      :job,
      :create,
      "ac5a4368-a0e3-4043-846c-354616bc7487",
      %{ a: 1, b: 2},
      %{}
    )
  end
end
