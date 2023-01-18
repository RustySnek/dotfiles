let
  # set ssh public keys here for your system and user
  host-gate = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJAg7g73+h8cdV0kyZZxn04wYY+agFFYJoXvDVWs7e+De6Dyd+wEbdsV7N6lW6+HXUmUDLhPd+b8n+AtlsdUKj28wQfm/XB4Ze5+kGJxSHQsJmrH75Tv4O9H2CaUnQMJFZivAEeNLVdrD2hESkPUdIgfCVHW9O3iquMAMJbsQPWvoZKyO+Iv8zPzilM2mhZfaUt5fQvr4HxujNnboiWMDE+/0ZUDcNy75xcFoJvfogAHRMjmEdoWs3snZg8Od0tqpFlKqWemWX0iyP7hroMXmes2y/s5i8zwSrtaZGU0YA2ZMmKqh/L/3b4N29g7UsjHBzt07n+FkvHyZHJtvx9t2uumSajl8ufR33ArtOSuI8fzpiOsEutj9ATdx6vQdrGqUqBREZ1vxYa1IdOvfox9dDXcR1sEVn/SuYuSwW2Y7rQT7tcMxUBHhhBjdlioQEbFY5Lk2HC42veAiKV6Wfj6tu3/4VQ3nDp2isu0nJEvQywVZrg0mNxx+NleTtYjnZFu6dZnUJTNhEYSv321gda6eEqWELymq5WLx3Cx0a3Va4RzRH9Z1/VsZH+oyguBOqYwOFDDTj/aXYEEFm1xnWmWJ4h/K/1PPWQZuZnX7lZ+yhDx/qTofGq3DqruyTATDRzBI0+2UETyG3MEntCIElV4ERi+5mOwktcthODyAV6T8Oew==";
  q-gate = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9/Egd80mpbwIYDC5PwCpdmm1+l36Bpr5ep33uuAT3fvTO0EDH5vOCV2MghaDvDT5ukf0M3R0PyE9JQO8J3KsaBzahSxy3IJ8mjccbERVBqAfXWn8IWUPkytveIfBVCrv3bqe9B+t/kiDMQD4ZIDg83WFseWQesuuKeCE6M/VExJbpptztCCWAehZuH7ngX0fQv//fXBqnmYrO8fDz+5QOpGqnWiBnJgSwrP+riAi09NSAJr82ShssVcZZ6OSv020MyKoWKkcK00Sp7A/r2mEDvMPl5DnIpXSqf/N03yJEkbg+2hMfT8XG4EM5xm3vdMm61FBNF39GTkDowsxvNNi/wEwOzmDLzq3Nr4QhvxFjus5Zeu0OW9+8ty/PcCtcB+k8MJogKiKg10U69sQj5zz8brAnxN45Xt5BVeFxYLgUTO45zphUWRk4T8AQoBTA21tLNV4MnFBPb8iZY/O5ef2NKQmIj5H5NyO5fAv9bnuCbDHCEDvuGmZM6II0uNapsME=";
  q-stein = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCudFt11/fgbwhSQ6YNKYfJ5cPgNnUprqyNMP8yRPS00+aIk2crAdoKgRdpcxyCf5Pqr1O0AELYsxBQdxKpvNffBPJI2zpFggsVzOP53EtwwoM76nwEWefHhMoeglBMp3ccuzVgvmoUgE1KKS3gkM4Bh6UUJk2nQmecYDLyjmjYj4+skYp9DA8CCZTM8nX82Xt8YvOJQPMZXj0HmsXHFxTLdYrZFnySu+Z79vVeAARoMS2LEe8HqKSfFVaHOR5KzaX/FP6fk3KXkmKGJLTH07jraI7O+BxxpU7/PSsAb7AEU5k/oKdYLKncnFvCW0fxdO1m0Qo8Sx2FqzEP/Exb0m3zmcPncciL8/IVL9MDVv0J3BdETYRySP5UOZADfp/af/ntW+Xpg1U8n5c1qCm7f4UAJrjKlLXVhgBOVEcatdyJ/O7Aq0pApFOQzrhyR5LiOAZgIiH+HOxzcIfyflUb7UhSSGI9Ve4LLQ8lwfTrWJIb8GakVFKCwFKgGTanIRI3pJU= q@stein";
  host-stein = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDE4wcgIHspOGpCijibKIVJBa9GKaWyuiqtLfPcAtaHFSBA4uxjNlRLBs/tA6KzkDiMSqxbDjS5yNJx6N5LuP51+51J21kfV3sho5UlnYWJttan4SzvVAv4aXNaI1XskFXBjEOuyNAS5D1i+9udKYcs0kJXlewWRJp1WqgZnIWaLZUEy4BQsRyZEOGBwuBZCYBX4BiarIADdJEXb/srXJkUDwtYNzJYpJanhBgrfPCGK5IQL8qc2ZhfQWfRTTWwE9gkUV7uWfWzKB7XoSn77r18PWk7aBfReRSdyG0U2J9i1fjTi33EEqoRm2pfiuwd66hW0RmHeIXmW8RQDkOJVzZ1ovLeDFz8CV8p/mQ5MwKMzg4cI2HJj9j19CU2LNMHPPAHHYb0mpW1xXOz2D+MMb45DwJ7YEf3NPeKQOffRjVgOfeldtkQrIfOev6vRVrH8X/OumtEn3/bgfZdnVsuL9ZMn2r9thCf+GNzviFGKZ3Fvw1x1o6YDYn1bJ+zeDi8kNxysODR5OTf4drkEYM2BwNN8zIpx1UNPJbBsWT4wHGuxuLsEqkG+OyfNCQpQu2opDgmR/iHyEYqKLeT+8R8YK4keHBkz92GMovrITEZCpIoCpAwmiTMbFHkRqicDTWFO+eOBDCqPU+V/nIPjfHAJ0hoqcRMi4eOIUIACi8sfSj3Kw==";
  allKeys = [ host-gate q-gate q-stein host-stein ];
in
{
  "users/root.age".publicKeys = allKeys;
  "users/q.age".publicKeys = allKeys;
  "tokens/google_api_token.age".publicKeys = allKeys;
  "tokens/lastfm_token.age".publicKeys = allKeys;
}
