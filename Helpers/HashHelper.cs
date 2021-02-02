using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace DonairHubWebApplication.Helpers
{
    public class HashHelper
    {
        public class RandomGenerator
        {
            private const string AllowableCharacters = "abcdefghijklmnopqrstuvwxyz0123456789";
            public static string GenerateString(int length)
            {
                var bytes = new byte[length];
                using (var random = RandomNumberGenerator.Create())
                {
                    random.GetBytes(bytes);
                }
                return new string(bytes.Select(x => AllowableCharacters[x % AllowableCharacters.Length]).ToArray());
            }
        }
        public string CalculateHash(string input)
        {
            var salt = GenerateSalt(16);
            var bytes = KeyDerivation.Pbkdf2(input, salt, KeyDerivationPrf.HMACSHA512, 10000, 16);
            return $"{ Convert.ToBase64String(salt) }:{ Convert.ToBase64String(bytes) }";
        }
        private static byte[] GenerateSalt(int length)
        {
            var salt = new byte[length];
            using (var random = RandomNumberGenerator.Create())
            {
                random.GetBytes(salt);
            }
            return salt;
        }

        public bool CheckMatch(string hash, string input)
        {
            try
            {
                var parts = hash.Split(':');
                var salt = Convert.FromBase64String(parts[0]);
                var bytes = KeyDerivation.Pbkdf2(input, salt, KeyDerivationPrf.HMACSHA512, 10000, 16);
                return parts[1].Equals(Convert.ToBase64String(bytes));
            }
            catch
            {
                return false;
            }
        }
    }
}

