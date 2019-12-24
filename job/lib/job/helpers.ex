defmodule Job.Helpers do

  def order( { _, object1 }, { _, object2 }, :asc ) do
    Map.get(object1, :order) > Map.get(object2, :order)
  end
  def order( { _, object1 }, { _, object2 }, :desc ) do
    Map.get(object1, :order) < Map.get(object2, :order)
  end

end
