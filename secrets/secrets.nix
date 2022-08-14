let
  # set ssh public keys here for your system and user
  host-gate = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJAg7g73+h8cdV0kyZZxn04wYY+agFFYJoXvDVWs7e+De6Dyd+wEbdsV7N6lW6+HXUmUDLhPd+b8n+AtlsdUKj28wQfm/XB4Ze5+kGJxSHQsJmrH75Tv4O9H2CaUnQMJFZivAEeNLVdrD2hESkPUdIgfCVHW9O3iquMAMJbsQPWvoZKyO+Iv8zPzilM2mhZfaUt5fQvr4HxujNnboiWMDE+/0ZUDcNy75xcFoJvfogAHRMjmEdoWs3snZg8Od0tqpFlKqWemWX0iyP7hroMXmes2y/s5i8zwSrtaZGU0YA2ZMmKqh/L/3b4N29g7UsjHBzt07n+FkvHyZHJtvx9t2uumSajl8ufR33ArtOSuI8fzpiOsEutj9ATdx6vQdrGqUqBREZ1vxYa1IdOvfox9dDXcR1sEVn/SuYuSwW2Y7rQT7tcMxUBHhhBjdlioQEbFY5Lk2HC42veAiKV6Wfj6tu3/4VQ3nDp2isu0nJEvQywVZrg0mNxx+NleTtYjnZFu6dZnUJTNhEYSv321gda6eEqWELymq5WLx3Cx0a3Va4RzRH9Z1/VsZH+oyguBOqYwOFDDTj/aXYEEFm1xnWmWJ4h/K/1PPWQZuZnX7lZ+yhDx/qTofGq3DqruyTATDRzBI0+2UETyG3MEntCIElV4ERi+5mOwktcthODyAV6T8Oew==";
  allKeys = [ host-gate ];
in
{
  "secret.age".publicKeys = allKeys;
}
