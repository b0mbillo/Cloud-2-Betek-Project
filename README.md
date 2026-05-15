# Cloud-2-Betek-Project
Proyecto 2 para el bootcamp Cloud 2 por parte de Betek

## Project Structure

# NexaCloud - Centro de Soporte Técnico Serverless

Plataforma de soporte técnico construida en **AWS con Lambdas** y **API Gateway**, con frontend en **HTML5 + CSS3 + Vanilla JavaScript**.

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
        │ POST /auth/login                        │
        │ POST /tickets/create                    │
        │ GET  /tickets/list                      │
        │ GET  /tickets/:id                       │
        │ PUT  /tickets/:id/update                │
        │ DELETE /tickets/:id/delete              │
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
- Hero section con llamada a la acción
- Sección de características
- Cómo funciona (6 pasos)
- Estadísticas de rendimiento
- FAQ con preguntas sobre arquitectura AWS
- Responsive design (mobile-first)

### 🔐 Página de Login (`login/login.html`)
- Autenticación con email y contraseña
- Integración con Lambda de autenticación
- Token JWT almacenado en `localStorage`
- Redirección automática a dashboard
- Recordar email (checkbox)

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
- Envío a Lambda via API Gateway
- Mensaje de éxito con ID de ticket

### 📊 Dashboard CRUD (`support/support.html`)
**Solo para personal de soporte**
- Estadísticas en tiempo real (Abiertos, En Progreso, Resueltos, Cerrados)
- Búsqueda por ID, cliente o asunto
- Filtros por estado y prioridad
- Pestañas: Todos, Asignados a mí, Urgentes
- **Acciones CRUD:**
  - 👁️ Ver detalles completos
  - ✏️ Editar estado, asignación y agregar notas
  - 🗑️ Eliminar tickets
  - ➕ Crear nuevos tickets manualmente

## 🔗 API Gateway Endpoints

Todos los endpoints requieren:
- **CORS habilitado** para solicitudes desde el frontend
- **JWT en header Authorization**: `Authorization: Bearer {token}`
- **Content-Type**: `application/json`

## Configurar el API Gateway

Editar `webpages/api-config.js` y actualiza:

```javascript
const API_CONFIG = {
    BASE_URL: ''
};
```

### Autenticación

#### POST `/auth/login`
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
**Respuesta exitosa:**
```json
{
  "success": true,
  "authToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": "user123",
  "email": "user@example.com"
}
```

### Tickets CRUD

#### POST `/tickets/create`
Crear nuevo ticket de soporte.
```json
{
  "fullname": "Juan Pérez",
  "email": "juan@example.com",
  "phone": "+57 3001234567",
  "category": "technical",
  "priority": "high",
  "subject": "Error al acceder",
  "description": "No puedo acceder a mi cuenta...",
  "attachments": 0,
  "createdAt": "2024-01-15T10:30:00Z"
}
```

#### GET `/tickets/list`
Listar todos los tickets.
**Respuesta:**
```json
{
  "success": true,
  "tickets": [
    {
      "id": "TK-001",
      "fullname": "Juan Pérez",
      "status": "open",
      "priority": "high"
    }
  ]
}
```

#### GET `/tickets/:id`
Obtener detalles de un ticket específico.

#### PUT `/tickets/:id/update`
Actualizar estado, asignación y agregar notas.
```json
{
  "status": "in-progress",
  "assignee": "Carlos López",
  "notes": "Investigando el problema..."
}
```

#### DELETE `/tickets/:id/delete`
Eliminar un ticket.


### Crear API Gateway

**AWS Console → API Gateway → Create API → REST API**

1. **Crear recurso** `/auth`
   - Crear método POST
   - Integración Lambda → `login-lambda`

2. **Crear recurso** `/tickets`
   - POST (crear ticket)
   - GET (listar tickets)

3. **Habilitar CORS** para todos los métodos

4. **Desplegar** en stage `default`

5. **Copiar URL base** y actualizar `api-config.js`

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
**Stack**: HTML5 + CSS3 + Vanilla JS + AWS Lambda + API Gateway + DynamoDB + S3 + Terraform

