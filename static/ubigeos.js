document.querySelectorAll("[data-ubigeo-form]").forEach((form) => {
    const departamento = form.querySelector("[data-ubigeo-departamento]");
    const provincia = form.querySelector("[data-ubigeo-provincia]");
    const distrito = form.querySelector("[data-ubigeo-distrito]");
    const ubigeoId = form.querySelector("[data-ubigeo-id]");
    const status = form.querySelector("[data-ubigeo-status]");

    function reset(select, placeholder) {
        select.replaceChildren(new Option(placeholder, ""));
        select.disabled = true;
    }

    async function fetchOptions(endpoint, params) {
        const url = new URL(endpoint, document.baseURI);
        Object.entries(params).forEach(([key, value]) => url.searchParams.set(key, value));
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error("La consulta de ubicación no pudo completarse.");
        }
        return response.json();
    }

    function populate(select, options, placeholder, valueKey, labelKey) {
        select.replaceChildren(new Option(placeholder, ""));
        options.forEach((item) => select.add(new Option(item[labelKey], item[valueKey])));
        select.disabled = options.length === 0;
    }

    async function loadDepartments() {
        try {
            const options = await fetchOptions(form.dataset.departamentosUrl, {});
            populate(
                departamento,
                options,
                "Selecciona un departamento",
                "departamento",
                "departamento"
            );
        } catch (error) {
            status.textContent =
                "No se pudieron cargar los departamentos. Actualiza la página e inténtalo de nuevo.";
        }
    }

    departamento.addEventListener("change", async () => {
        const selectedDepartment = departamento.value;
        reset(provincia, "Selecciona una provincia");
        reset(distrito, "Selecciona primero una provincia");
        ubigeoId.value = "";
        status.textContent = "";
        if (!selectedDepartment) return;
        try {
            const options = await fetchOptions(form.dataset.provinciasUrl, {
                departamento: selectedDepartment
            });
            if (selectedDepartment !== departamento.value) return;
            populate(provincia, options, "Selecciona una provincia", "provincia", "provincia");
            if (!options.length) status.textContent = "No hay provincias activas para este departamento.";
        } catch (error) {
            if (selectedDepartment === departamento.value) {
                status.textContent = "No se pudieron cargar las provincias. Actualiza la página e inténtalo de nuevo.";
            }
        }
    });

    provincia.addEventListener("change", async () => {
        const selectedDepartment = departamento.value;
        const selectedProvince = provincia.value;
        reset(distrito, "Selecciona un distrito");
        ubigeoId.value = "";
        status.textContent = "";
        if (!selectedProvince) return;
        try {
            const options = await fetchOptions(form.dataset.distritosUrl, {
                departamento: selectedDepartment,
                provincia: selectedProvince
            });
            if (selectedDepartment !== departamento.value || selectedProvince !== provincia.value) return;
            populate(distrito, options, "Selecciona un distrito", "id_ubigeo", "distrito");
            if (!options.length) status.textContent = "No hay distritos activos para esta provincia.";
        } catch (error) {
            if (selectedDepartment === departamento.value && selectedProvince === provincia.value) {
                status.textContent = "No se pudieron cargar los distritos. Actualiza la página e inténtalo de nuevo.";
            }
        }
    });

    distrito.addEventListener("change", () => {
        ubigeoId.value = distrito.value;
        status.textContent = "";
    });

    form.addEventListener("submit", (event) => {
        if (departamento.matches(":disabled")) return;
        const direccion = form.querySelector("[data-ubigeo-address]");
        const direccionIngresada = direccion ? Boolean(direccion.value.trim()) : false;
        const esUbigeoInvalido = form.hasAttribute("data-ubigeo-optional")
            ? Boolean(ubigeoId.value) !== direccionIngresada
                || (ubigeoId.value && ubigeoId.value !== distrito.value)
            : !ubigeoId.value || ubigeoId.value !== distrito.value;
        if (esUbigeoInvalido) {
            event.preventDefault();
            status.textContent = form.hasAttribute("data-ubigeo-optional")
                ? "Ingresa la dirección fiscal y selecciona departamento, provincia y distrito, o deja ambos vacíos."
                : "Selecciona departamento, provincia y distrito para continuar.";
            distrito.focus();
        }
    });

    loadDepartments();
});
