requires "Carp" => "0";
requires "Class::Method::Modifiers" => "0";
requires "Exporter" => "0";
requires "List::Util" => "1.33";
requires "List::UtilsBy" => "0.09";
requires "Module::Runtime" => "0.013";
requires "Role::Tiny" => "1.003";
requires "Scalar::Util" => "0";
requires "Type::Tie" => "0.004";
requires "autobox" => "0";
requires "overload" => "0";
requires "parent" => "0";
requires "strictures" => "1";
recommends "List::UtilsBy::XS" => "0.03";
recommends "Type::Tiny" => "0.022";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "Test::More" => "0.88";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
  recommends "JSON::PP" => "0";
  recommends "Test::Without::Module" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Synopsis" => "0";
};
