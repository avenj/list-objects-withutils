requires "parent"                   => "0";
requires "Exporter"                 => "0";
requires "strictures"               => "1";

requires "Class::Method::Modifiers" => "0";
requires "Module::Runtime"          => "0.013";
requires "Role::Tiny"               => "1.003";

requires "Type::Tiny"               => "0";
requires "Type::Tie"                => "0.004";

requires "List::UtilsBy"            => "0.09";
recommends "List::UtilsBy::XS"      => "0.03";

on 'test' => sub {
  requires "Test::More" => "0.88";

  recommends "JSON::PP" => "0";
  recommends "Test::Without::Module" => "0";
};
