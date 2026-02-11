terraform { # Ye block provider define karne ke liye 

  required_providers { #required provider block kyu use karte hai? - Terraform ke paas by default AWS / Azure / GCP ka knowledge nahi hota
    # Isiliye hum is block me sari chize define karte hai aur terraform ko batate hai

    # Why azurerm - Azure Resource Manager ka provider (Matlab: Azure ke resources banane / manage karne ka tool)
    azurerm = {                     # Which Cloud is being used 
      source  = "hashicorp/azurerm" # From where this block is sourced and downloaded 
      version = "4.58.0"            # Version of this provider
    }
  }
}

provider "azurerm" {  # Ye block Terraform ko btaneke liye ki ye credentials & settings use karke Azure me login kar
  features {}                                              #Required block - Ye Azure provider ka mandatory block hai
  subscription_id = "197948ef-973c-4ecc-89ae-2c6259878bb3" #Required argument - Yha specific subcription deni hai qyuki fir terraform usi subscription me resources banata hai 
}


# | Terraform       | Real Life                              |
# | --------------- | -------------------------------------- |
# | provider        | Bike                                   |
# | version         | Bike model                             |
# | subscription_id | Road (kaha chalani hai)                |
# | features {}     | Helmet (mandatory, bhale hi silent ho) |
