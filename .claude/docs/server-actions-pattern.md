# Server Actions Pattern Guide

Server Actions replace the axios + API route pattern for form mutations in Next.js. They provide:
- Automatic cache revalidation
- Server-side redirects
- Type-safe error handling
- Smaller client bundle

---

## ActionState Return Type

All actions return a consistent shape:

```typescript
export type ActionState = {
  success: boolean
  error?: string
  fieldErrors?: Record<string, string[]>
}
```

Define this in `src/types/actions.ts` and import it everywhere.

---

## Two Action Variants

### 1. Object Actions (for react-hook-form)

Used when calling a server action directly from `handleSubmit`:

```typescript
'use server'

export async function createThingAction(data: unknown): Promise<ActionState> {
  // 1. Auth check
  const session = await auth()
  if (!session) return { success: false, error: 'Unauthorized' }

  // 2. Validate
  const validation = thingSchema.safeParse(data)
  if (!validation.success) {
    return {
      success: false,
      error: 'Validation failed',
      fieldErrors: validation.error.flatten().fieldErrors,
    }
  }

  // 3. Database operation
  try {
    await db.thing.create({ data: validation.data })
  } catch {
    return { success: false, error: 'Failed to create' }
  }

  // 4. Revalidate and redirect
  revalidatePath('/things')
  redirect('/things')
}
```

### 2. FormData Actions (for native forms)

Used with `useFormState` and native `<form action={...}>`:

```typescript
'use server'

export async function createThing(
  prevState: ActionState | null,
  formData: FormData
): Promise<ActionState> {
  const session = await auth()
  if (!session) return { success: false, error: 'Unauthorized' }

  const data = Object.fromEntries(formData)
  const validation = thingSchema.safeParse(data)
  if (!validation.success) {
    return { success: false, fieldErrors: validation.error.flatten().fieldErrors }
  }

  try {
    await db.thing.create({ data: validation.data })
  } catch {
    return { success: false, error: 'Failed to create' }
  }

  revalidatePath('/things')
  redirect('/things')
}
```

---

## Client Component Patterns

### With react-hook-form (recommended for complex forms)

```typescript
'use client'
import { useState, useTransition } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { createThingAction } from '@/lib/actions/things'

export function ThingForm() {
  const [error, setError] = useState('')
  const [isPending, startTransition] = useTransition()

  const { handleSubmit, register } = useForm({
    resolver: zodResolver(thingSchema),
  })

  const onSubmit = handleSubmit(async (formData) => {
    setError('')
    startTransition(async () => {
      try {
        const result = await createThingAction(formData)
        if (!result.success && result.error) {
          setError(result.error)
        }
      } catch (err) {
        // redirect() throws — this is expected and safe to ignore
        if (err instanceof Error && !err.message.includes('NEXT_REDIRECT')) {
          setError('An unexpected error occurred')
        }
      }
    })
  })

  return (
    <form onSubmit={onSubmit}>
      {error && <p className="text-red-500">{error}</p>}
      <input {...register('name')} />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Saving...' : 'Save'}
      </button>
    </form>
  )
}
```

### With native form + useFormState (simpler forms)

```typescript
'use client'
import { useFormState, useFormStatus } from 'react-dom'
import { createThing } from '@/lib/actions/things'

function SubmitButton() {
  const { pending } = useFormStatus()
  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Saving...' : 'Save'}
    </button>
  )
}

export function ThingForm() {
  const [state, formAction] = useFormState(createThing, null)

  return (
    <form action={formAction}>
      {state?.error && <p className="text-red-500">{state.error}</p>}
      <input name="name" required />
      <SubmitButton />
    </form>
  )
}
```

---

## When to Use Each Pattern

**Use react-hook-form + Object Actions when:**
- Form has complex validation
- Using controlled components (Select, DatePicker, etc.)
- Need client-side validation feedback before submit
- Form has conditional fields

**Use native form + FormData Actions when:**
- Simple forms with basic inputs
- Progressive enhancement needed
- Fewer dependencies preferred

---

## File Structure Convention

```
src/
  lib/
    actions/
      things.ts      ← CRUD actions for "things"
      users.ts       ← CRUD actions for "users"
  types/
    actions.ts       ← ActionState type
```

---

## Comparison with API Routes

| API Route Pattern | Server Action Pattern |
|-------------------|-----------------------|
| `fetch('/api/things', { method: 'POST' })` | `await createThingAction(data)` |
| `router.refresh()` after mutation | `revalidatePath()` in the action |
| `router.push('/things')` | `redirect('/things')` in the action |
| Manual `isSubmitting` state | `useTransition` or `useFormStatus` |
| Error in catch block | Error in returned `ActionState` |
