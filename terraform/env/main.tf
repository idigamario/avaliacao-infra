module "avaliacao" {
    source = "../infra"

    cluster_name = "avaliacao-infra"
}

output "endereco" {
    value = module.avaliacao.URL
}