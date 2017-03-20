defmodule SluggerTest do
  use ExUnit.Case
  doctest Slugger

  #--- slugify()

  test "string keep case" do
    assert Slugger.slugify("ABC") == "ABC"
  end

  test "removing space at beginning" do
    assert Slugger.slugify(" \t \n ABC") == "ABC"
  end

  test "removing space at ending" do
    assert Slugger.slugify("ABC \n  \t \n ") == "ABC"
  end

  test "removing space at ending and ending" do
    assert Slugger.slugify(" \n  \t \n ABC \n  \t \n ") == "ABC"
  end

  test "replace whitespace inside with seperator" do
    assert Slugger.slugify("   A B  C  ") == "A-B-C"
    assert Slugger.slugify("   A B  C  ", ?_) == "A_B_C"
  end
  
  test "replace multiple seperator inside and outside" do
	assert Slugger.slugify("--a--b c - - - ") == "a-b-c"
  end

  test "replace special char with expected string" do
    assert Slugger.slugify("üba") == "ueba"
    assert Slugger.slugify("büa") == "buea"
    assert Slugger.slugify("baü") == "baue"
    assert Slugger.slugify("büaü") == "bueaue"
  end
  
  #--- slugify_downcase()
  
  test "string to lower" do
    assert Slugger.slugify_downcase("ABC") == "abc"
  end

  test "removing space at beginning lowercase" do
    assert Slugger.slugify_downcase(" \t \n ABC") == "abc"
  end

  test "removing space at ending lowercase" do
    assert Slugger.slugify_downcase("ABC \n  \t \n ") == "abc"
  end

  test "removing space at ending and ending lowercase" do
    assert Slugger.slugify_downcase(" \n  \t \n ABC \n  \t \n ") == "abc"
  end

  test "replace whitespace inside with seperator lowercase" do
    assert Slugger.slugify_downcase("   A B  C  ") == "a-b-c"
    assert Slugger.slugify_downcase("   A B  C  ", ?_) == "a_b_c"
  end

  #--- Naughty strings

  test "naughty strings" do
    "test/big-list-of-naughty-strings/blns.json"
    |> File.read!
    |> Poison.decode!
    |> Enum.each(fn(string) ->
      assert is_binary Slugger.slugify(string)
      assert is_binary Slugger.slugify_downcase(string)
    end)
  end

  #--- Application config

  test "config defaults" do
    Application.load(:slugger)

    assert Application.get_env(:slugger, :separator_char) == ?-
    assert Application.get_env(:slugger, :replacement_file) == "lib/replacements.exs"

    assert Slugger.slugify("a ü") == "a-ue"
  end

end
