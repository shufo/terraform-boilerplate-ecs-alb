/**
 * Root zone for route53
 */
resource "aws_route53_zone" "primary" {
    name       = "${var.route53_zone}"
    comment    = "Zone for ${var.project}"

    tags {
        name = "${var.project}"
        Group = "${var.project}"
    }
}

/**
 * NS Records
 */
resource "aws_route53_record" "ns" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.route53_zone}"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.primary.name_servers.0}",
        "${aws_route53_zone.primary.name_servers.1}",
        "${aws_route53_zone.primary.name_servers.2}",
        "${aws_route53_zone.primary.name_servers.3}"
    ]
}
