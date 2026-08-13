import child_process from "node:child_process";
import fs from "node:fs";

export function render(
    theme = { variables: {} },
    templates
) {
    for (const template of templates) {
        const source = typeof template.source === "function"
            ? template.source(theme)
            : template.source;

        const destination = typeof template.destination === "function"
            ? template.destination(theme)
            : template.destination;

        if (source && destination) {
            const raw = fs.readFileSync(source, "utf8");

            function transform(raw, theme) {
                let transformed = raw;

                for (const [key, value] of Object.entries(theme.variables)) {
                    transformed = transformed.replaceAll(`{${key}}`, value);
                }

                return transformed;
            }

            const transformed = typeof template.transform === "function"
                ? template.transform(raw, theme, transform)
                : transform(raw, theme);

            fs.writeFileSync(destination, transformed);
        }

        if (typeof template.command === "function") {
            template.command(theme);
        }
    }
}

export function restart(proc) {
    const pid = child_process.execSync(`pidof ${proc} || true`, { encoding: "utf8" }).trim();

    if (pid) {
        child_process.execSync(`kill ${pid}`);
    }

    const child = child_process.spawn(proc, {
        detached: true,
        stdio: "ignore"
    });

    child.unref();
}
