# Cloud-2-Betek-Project
Proyecto 2 para el bootcamp Cloud 2 por parte de Betek

# NexaCloud - Centro de Soporte Técnico Serverless

Plataforma de soporte técnico construida en **AWS con Lambdas** y **API Gateway**, con frontend en **HTML5 + CSS3 + Vanilla JavaScript**.

**Stack**: HTML5 + CSS3 + Vanilla JS + AWS Lambda + API Gateway + DynamoDB + S3 + Terraform

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend on S3                       │
│         HTML5 + CSS3 + Vanilla JavaScript               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │ Index Page   │  │ Login Page   │  │ Form Page    │   │
│  └──────────────┘  └──────────────┘  └──────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Support Dashboard (CRUD)                        │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          ↓
            ┌─────────────────────────────┐
            │   AWS API Gateway           │
            │ (Enrutamiento + CORS)       │
            └─────────────────────────────┘
                          ↓
        ┌─────────────────────────────────────────┐
        │         AWS Lambda Functions            │
        ├─────────────────────────────────────────┤
        │ POST /tickets/create                    │
        │ GET  /tickets/list                      │
        │ GET  /tickets/:id                       │
        │ PUT  /tickets/:id/update                │
        └─────────────────────────────────────────┘
                          ↓
            ┌─────────────────────────────┐
            │   DB                        │
            │   (DynamoDB)                │
            └─────────────────────────────┘
```

## 📁 Estructura de Directorios

```
Cloud-2-Betek-Project/
├── LICENSE
├── README.md
├── .github/
│   └── workflows/
│       └── deploy.yaml
├── doc/
│   ├── proyecto-betek.drawio         # Diagrama de arquitectura
│   └── tree.txt                      # Estructura del proyecto
├── terraform/                         # IaC
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   ├── versions.tf
│   └── modules/
│       ├── API_gateway/
│       │   ├── main.tf
│       │   └── variables.tf
│       ├── DynamoDB/
│       │   ├── main.tf
│       │   └── variables.tf
│       ├── Lambda/
│       │   ├── main.tf
│       │   └── variables.tf
│       └── S3/
│           ├── main.tf
│           └── variables.tf
└── webpages/
    ├── api-config.js                 # ⭐ Configuración centralizada del API
    ├── style.css                     # Estilos globales
    ├── index/
    │   ├── index.html               # Página de inicio
    │   ├── index-style.css          # Estilos específicos de índice
    │   └── index-nav.html           # Navbar para índice
    ├── login/
    │   ├── login.html               # Página de login
    │   ├── login-style.css          # Estilos de login
    │   └── login-nav.html           # Navbar para login
    ├── form/
    │   ├── form.html                # Formulario de creación de tickets
    │   ├── form-style.css           # Estilos del formulario
    │   └── form-nav.html            # Navbar para formulario
    └── support/
        ├── support.html             # Dashboard CRUD
        ├── support-style.css        # Estilos del dashboard
        └── support-nav.html         # Navbar para dashboard
```

## 📊 Funcionalidades

### ✅ Página de Inicio (`index.html`)
- Entrada principal en raíz: `webpages/index.html` (redirige a `webpages/index/index.html`)
- Sección principal con descripción del sistema
- Sección de características
- Cómo funciona (6 pasos) orientado al flujo real de atención
- Estadísticas de rendimiento
- FAQ con preguntas no técnicas para clientes
- Responsive design (mobile-first)

### 🔐 Página de Login (`login/login.html`)
- Autenticación con email y contraseña
- Integración con AWS Cognito
- Tokens de sesión almacenados en `sessionStorage`
- Redirección automática a dashboard
- Recordar email (checkbox)
- Recuperación de contraseña

### 📝 Formulario de Tickets (`form/form.html`)
- Creación de tickets con:
  - Nombre completo
  - Email
  - Teléfono
  - Categoría (Técnico, Facturación, Cuenta, General)
  - Prioridad (Baja, Media, Alta)
  - Asunto (max 100 caracteres)
  - Descripción (max 2000 caracteres)
  - Adjuntos (drag & drop, max 5MB)
- Validación cliente-side
- Envío vía API Gateway
- Mensaje de éxito con ID de ticket
- Acceso público (no requiere login)

### 📊 Dashboard de Soporte (`support/support.html`)
**Solo para personal de soporte**
- Estadísticas en tiempo real (Abiertos, En Progreso, Resueltos, Cerrados)
- Búsqueda por ID, cliente o asunto
- Filtros por estado y prioridad
- Pestañas: Todos, Asignados a mí, Urgentes
- **Acciones disponibles:**
  - 👁️ Ver detalles completos
  - ✏️ Editar estado, asignación y agregar notas
  - ➕ Crear nuevos tickets manualmente

## Autenticación

**⭐ AUTENTICACIÓN**: AWS Cognito se usa **solo para acceder al panel de soporte**.  
> Para crear/enviar tickets **NO se requiere autenticación**.

### 🔐 Política de Autenticación

| Funcionalidad | Requiere Cognito | Acceso |
|---|---|---|
| 📝 Crear Ticket | ❌ No | Público - Cualquiera |
| 📋 Ver Panel de Soporte | ✅ Sí | Solo usuarios autenticados |
| 🔐 Login | ✅ Sí | Para acceder al panel |

## 🔗 API Gateway

Todos los endpoints requieren:
- **CORS habilitado** para solicitudes desde el frontend
- **JWT en header Authorization**: `Authorization: Bearer {token}`
- **Content-Type**: `application/json`

### Endpoints Tickets CRUD
- POST `/tickets/create`: Crear nuevo ticket (público)
- GET `/tickets/list`: Listar todos los tickets (soporte)
- GET `/tickets/:id`: Obtener detalles de un ticket (soporte)
- PUT `/tickets/:id/update`: Actualizar estado, asignación y notas (soporte)

### Configurar el API Gateway

Editar `webpages/api-config.js` y actualiza:

```javascript
const API_CONFIG = {
    BASE_URL: ''
};
```

## 📝 Notas de Desarrollo

### api-config.js
Este archivo **centraliza toda la configuración del API**:
- `BASE_URL`: URL base del API Gateway
- `getApiUrl()`: Construye URLs completas
- `getAuthHeaders()`: Incluye JWT automáticamente
- `apiCall()`: Wrapper generic para fetch con manejo de errores
- Funciones helper: `loginUser()`, `createTicket()`, `getAllTickets()`, etc.

**Uso:**
```javascript
// En cualquier página
const response = await loginUser('user@example.com', 'password123');
const tickets = await getAllTickets();
const newTicket = await createTicket(ticketData);
```

## 📞 Soporte y Contacto

Brando Yesid Montoya Jaramillo - [linkedin.com/in/brando-montoya](https://www.linkedin.com/in/brando-montoya/)

---
