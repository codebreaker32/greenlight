# Voting rules

Agreed in issue #2: **weighted votes** and a **small-change fast path**. Agents can't see emoji reactions and reject `!commands`, so everything is typed.

## 1. Small change or big change

After both reviews are in, Juno decides:

- **Small change** if all four checks are ✅ **and** nobody is affected at a medium or high level.
  - No idea room vote. Juno tells the proposer it can go ahead.
  - Juno asks: "Should I let <names with low impact> know? (yes/no)". On yes, Juno posts a short note in `#greenlight`, writing names without `@`.
  - Juno saves `decisions/<id>-<slug>.md` with status `fast-track`.
- **Big change** in every other case (any ⚠ or ❌, or anyone at medium or high). Then the vote below runs.

## 2. Joining (consent)

1. Juno asks the proposer: "These people are affected: <names>. Invite them? (yes/no)". On no, the idea stays a private draft.
2. For each affected person, Juno asks in **that person's own personal room**: "You're invited to idea-<id>-<slug> about <title>. Reply accept or decline."
3. On `accept`, Juno adds them with `add_users_to_room`. On `decline`, or no answer, they are **not participating**. They don't block anything.
4. People whose `slack` is `TBD` or `none` in `team/people.yml` aren't invited; they're marked **not on Slack** (not participating).

## 3. Votes (typed in the idea room)

```
@vote-agent vote approve
@vote-agent vote reject: <reason>
@vote-agent vote changes: <what should change>
@vote-agent close vote          (proposer only)
@vote-agent status              (anyone: shows weights and the running count)
```

- One vote per person. A new vote **replaces** the old one.
- Only **participants** can vote: the proposer plus everyone who accepted. Votes from anyone else are ignored, and vote-agent says so.
- `reject` and `changes` need a reason. Without one, vote-agent asks for it and doesn't count the vote yet.

## 4. Weights

| Who | Weight |
|---|---|
| Impact **high** | 3 |
| Impact **medium** | 2 |
| Impact **low** | 1 |
| `seniority: senior` or `lead` (in Parcelwise `team/people.yml`) | +1 |
| **Proposer** | 1 (no bonus) |

Impact levels come from impact-agent's review in `ideas/<id>/review.md`. Vote-agent posts every participant's weight when voting opens, so it's transparent.

## 5. When the vote closes

There is no scheduler, so closing happens on a message:

- when **every participant has voted**, or
- when the proposer types `@vote-agent close vote`.

**Quorum:** at least 3 votes, or every participant if there are fewer than 3. Without quorum, vote-agent refuses to close and says how many votes are missing.

## 6. Result

1. Add up the weight behind each option: approve, reject, changes.
2. An option that has **more than half of the total weight cast** wins.
3. **Tie, or no option over half:** the **project owner** (`project_owner: true` in Parcelwise `team/people.yml`, now Bhawna) decides with `@vote-agent owner decides approve|reject|changes`.
4. **Blocker:** if either review has a ❌, `approve` can't win. If approve would have won, the result becomes `changes`, with the blocker as the reason.

| Result | What happens |
|---|---|
| approved | Decision saved, posted to `#greenlight`, room archived |
| rejected | Decision and reasons saved, posted, room archived |
| changes | Saved with the requested changes. The proposer revises with Juno, both reviewers check again, and a new vote is held (revision loop, nice to have) |

## 7. Demo example (idea 001)

| Person | Why | Weight | Vote |
|---|---|---|---|
| Bhawna | high impact + lead | 4 | approve (after her refactor and the freeze) |
| Dev | medium impact | 2 | approve |
| Riya | low impact | 1 | changes: add refund steps to the playbook first |
| Aman | proposer | 1 | approve |

Approve has 7 of 8 weight, which is more than half, so the idea is **approved**.

Everyone in this example is on Slack (Dev and Riya through demo accounts). Alex (mobile) isn't affected, so he isn't invited. If someone has `slack: none` or `TBD`, they're marked **not on Slack** and the weight total shrinks accordingly.
